from flask import Flask, render_template, url_for, request, make_response
from flask.ext.paginate import Pagination
from flask import Blueprint
import cubes
import os.path
from cubes.server import slicer, workspace
import sqlalchemy
from cubes import PointCut
from flask.ext.wtf import Form
from wtforms import StringField, SubmitField, SelectMultipleField, SelectField, widgets
from wtforms.validators import Required
from flask.ext.wtf import Form, widgets
from wtforms import SelectMultipleField, widgets

#
# The Flask Application
#
app = Flask(__name__)
app.secret_key = 'development key'

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

CUBESVIEWER_CUBES_URL = "http://localhost:5000"
CUBESVIEWER_BACKEND_URL = "http://localhost:8000/cubesviewer"

MODEL_PATH = os.path.join(APP_ROOT, "model.json")
DB_URL = "postgresql://richardbanyi:dpcu923@localhost:5432/usaspending"
CUBE_NAME = "spending"


class MultiCheckboxField(SelectMultipleField):
    widget = widgets.ListWidget(prefix_label=False)
    option_widget = widgets.CheckboxInput()


class FilterForm(Form):
    state = SelectField('State')
    city = SelectField('City', coerce=int)
    agency = SelectField('Agency')
    year = SelectField('Year')
    month = SelectField('Month', coerce=int)
    zip_code = StringField('Zip')
    recipient = StringField('Recipient')
    award_type = MultiCheckboxField('Award Type', choices= [('1', 'Contract')])


@app.route("/")
def template_test():
    return render_template('template.html', my_string="Hello World")

@app.route("/cubesviewer")
def cubesviewer():
    return render_template('cubesviewer.html',
            cubesviewer_backend_url=CUBESVIEWER_BACKEND_URL,
            cubesviewer_cubes_url= CUBESVIEWER_CUBES_URL)


@app.route("/charts", methods=['GET', 'POST'])
def charts():
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)

    states = []
    agencies = []
    years = []

    geography_cut = PointCut("geography", ["usa"])
    geo_cell = cubes.Cell(browser.cube, [geography_cut])
    cell_ = cubes.Cell(browser.cube)

    geo_members = browser.members(geo_cell, "geography")
    ag_members = browser.members(cell_, "agency")
    date_members = browser.members(cell_, "date")

    for member in date_members:
        if(member["date.year"] != "N\A"):
            years.append(member["date.year"])

    for member in ag_members:
        if(member["agency.awarding_agency"] != "N\A"):
            agencies.append(member["agency.awarding_agency"])

    for member in geo_members:
        if(member["geography.state"] != "N\A"):
            states.append(member["geography.state"])

    states = sorted(set(states))
    agencies = sorted(set(agencies))
    years = sorted(set(years))

    form = FilterForm(request.form)
    form.agency.choices = [(v, v) for v in agencies]
    form.state.choices = [(v, v) for v in states]
    form.year.choices = [(v, v) for v in years]

    if request.method == 'POST':
        if request.form['submit'] == 'sub_agency':
            cut = [
                    PointCut("date", [int(form.year.data)]),
                    PointCut("agency", [form.agency.data])
                    ]

            cell = cubes.Cell(browser.cube, cut)
            result = browser.aggregate(cell, drilldown=["transaction_type"])

            return render_template('agency_summary.html', result=result, form=form)

        if request.form['submit'] == 'sub_state':
            cut = [
                    PointCut("date", [int(form.year.data)]),
                    PointCut("geography", ["usa", form.state.data],
                                hierarchy="cscz")
                    ]

            cell = cubes.Cell(browser.cube, cut)
            result = browser.aggregate(cell, drilldown=["geography"])

            return render_template('state_summary.html', result=result, form=form)
    else:
        return render_template('charts.html', form=form)


@app.route("/charts/summary", methods=['GET', 'POST'])
def summary():
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)
    form = FilterForm(request.form)

    if request.method == 'POST':
        if request.form['submit'] == 'sub_agency':
            cut = [
                    PointCut("date", [int(form.year.data)]),
                    PointCut("agency", [form.agency.data])
                    ]

            cell = cubes.Cell(browser.cube, cut)
            result = browser.aggregate(cell)

            return render_template('agency_summary.html', result=result)

        if request.form['submit'] == 'sub_state':
            cut = [
                    PointCut("date", [int(form.year.data)]),
                    PointCut("geography", ["usa", form.state.data])
                    ]

            cell = cubes.Cell(browser.cube, cut)
            result = browser.aggregate(cell)

            return render_template('state_summary.html', result=result)



@app.route("/charts/<dim_name>")
def drilldown_charts(dim_name=None):
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)

    states = []
    agencies = []
    years = []

    geography_cut = PointCut("geography", ["usa"])
    geo_cell = cubes.Cell(browser.cube, [geography_cut])
    cell_ = cubes.Cell(browser.cube)

    geo_members = browser.members(geo_cell, "geography")
    ag_members = browser.members(cell_, "agency")
    date_members = browser.members(cell_, "date")

    for member in date_members:
        if(member["date.year"] != "N\A"):
            years.append(member["date.year"])

    for member in ag_members:
        if(member["agency.awarding_agency"] != "N\A"):
            agencies.append(member["agency.awarding_agency"])

    for member in geo_members:
        if(member["geography.state"] != "N\A"):
            states.append(member["geography.state"])

    states = sorted(set(states))
    agencies = sorted(set(agencies))
    years = sorted(set(years))

    form = FilterForm(request.form)
    form.agency.choices = [(v, v) for v in agencies]
    form.state.choices = [(v, v) for v in states]
    form.year.choices = [(v, v) for v in years]

    if not dim_name:
        return render_template('charts.html', dimensions=cube.dimensions)

    dimension = cube.dimension(dim_name)
    hierarchy = dimension.hierarchy()

    cutstr = request.args.get("cut")
    cell = cubes.Cell(browser.cube, cubes.cuts_from_string(cube, cutstr))

    cut = cell.cut_for_dimension(dimension)

    if cut:
        path = cut.path
    else:
        path = []

    result = browser.aggregate(cell, drilldown=[dim_name])

    if path:
        details = browser.cell_details(cell, dimension)[0]
    else:
        details = []

    levels = hierarchy.levels_for_path(path)
    if levels:
        next_level = hierarchy.next_level(levels[-1])
    else:
        next_level = hierarchy.next_level(None)

    is_last = hierarchy.is_last(next_level)


    return render_template( dim_name+'_chart.html',
                            dimensions=cube.dimensions,
                            dimension=dimension,
                            levels=levels,
                            next_level=next_level,
                            result=result,
                            cell=cell,
                            is_last=is_last,
                            details=details,
                            chart="Charts",
                            form=form
                            )


@app.route("/spending/all", methods=['GET', 'POST'])
def all():
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)

    # states, cities, agencies, years, months = spending()

    page = int(request.args.get('page', 0))

    if request.method == 'POST':
        if request.form['submit'] == 'reset':
            geo_cut = PointCut("geography", ["usa"])
            cell = cubes.Cell(browser.cube, [geo_cut])

            result = browser.aggregate(cell, drilldown=["recipient"], page=page, page_size=10)

            pagination = Pagination(page=page, css_framework='foundation', total=result.total_cell_count, per_page=10)

            return render_template('all.html', result=result,
                                                pagination=pagination)
        if request.form['submit'] == 'go':
            cuts = []
            if request.form['year']:
                if request.form['month'] != "View All":
                    cuts.append(PointCut("date", [int(request.form["year"]),
                                                    int(request.form["month"])]))
                else:
                    cuts.append(PointCut("date", [int(request.form["year"])]))

            if request.form["state"] != "View All":
                if request.form["city"] != "View All":
                    cuts.append(PointCut("geography", ["usa", request.form["state"],
                                                    request.form["city"]], hierarchy="cscz"))
                else:
                    cuts.append(PointCut("geography", ["usa", request.form["state"]]))

            if request.form["agency"] != "View All":
                cuts.append(PointCut("agency", [request.form["agency"]]))

            if request.form["zip"]:
                cuts.append(PointCut("geography", ["usa", request.form["zip"]], hierarchy="cz"))

            cell = cubes.Cell(browser.cube, cuts)

            # page = int(request.args.get('page', 0))

            result = browser.aggregate(cell, drilldown=["recipient"], page=page, page_size=10)

            pagination = Pagination(page=page, css_framework='foundation', total=result.total_cell_count, per_page=10)

            return render_template('all.html', result=result,
                                                pagination=pagination)


@app.route("/spending_copy", methods=['GET', 'POST'])
def spending_copy():
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)
    result = browser.aggregate()

    states = []
    cities = []
    agencies = []
    years = []
    months = []

    geography_cut = PointCut("geography", ["usa"])

    geo_cell = cubes.Cell(browser.cube, [geography_cut])
    cell = cubes.Cell(browser.cube)

    geo_members = browser.members(geo_cell, "geography")
    ag_members = browser.members(cell, "agency")
    date_members = browser.members(cell, "date")

    for member in date_members:
        if(member["date.year"] != "N\A"):
            years.append(member["date.year"])
        if(member["date.month"] != "N\A"):
            months.append(member["date.month"])

    for member in ag_members:
        if(member["agency.awarding_agency"] != "N\A"):
            agencies.append(member["agency.awarding_agency"])

    for member in geo_members:
        if(member["geography.state"] != "N\A"):
            states.append(member["geography.state"])
        if(member["geography.city"] != "N\A"):
            cities.append(member["geography.city"])

    states = sorted(set(states))
    cities = sorted(set(cities))
    agencies = sorted(set(agencies))
    years = sorted(set(years))
    months = sorted(set(months))

    form = FilterForm(request.form)
    form.agency.choices = [(k, v) for k, v in enumerate(agencies)]
    form.state.choices = [(k, v) for k, v in enumerate(states)]
    form.city.choices = []

    if request.method == 'GET':
        if form.state.data:
            cities2 = []
            cut = PointCut("geography", ["usa", form.state.data[1]])
            cell = cubes.Cell(browser.cube, [cut])
            city_mem = browser.members(cell, "geography")
            for member in city_mem:
                if(member["geography.city"] != "N\A"):
                    cities2.append(member["geography.city"])
            cities2 = sorted(set(cities2))
            form.city.choices = [(k, v) for k, v in enumerate(cities2)]
    # return [states, cities, agencies, years, months]
    return render_template('spending_copy.html', form=form)


@app.route("/spending")
def spending():
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)
    result = browser.aggregate()

    states = []
    cities = []
    agencies = []
    years = []
    months = []

    geography_cut = PointCut("geography", ["usa"])

    geo_cell = cubes.Cell(browser.cube, [geography_cut])
    cell = cubes.Cell(browser.cube)

    geo_members = browser.members(geo_cell, "geography")
    ag_members = browser.members(cell, "agency")
    date_members = browser.members(cell, "date")

    for member in date_members:
        if(member["date.year"] != "N\A"):
            years.append(member["date.year"])
        if(member["date.month"] != "N\A"):
            months.append(member["date.month"])

    for member in ag_members:
        if(member["agency.awarding_agency"] != "N\A"):
            agencies.append(member["agency.awarding_agency"])

    for member in geo_members:
        if(member["geography.state"] != "N\A"):
            states.append(member["geography.state"])
        if(member["geography.city"] != "N\A"):
            cities.append(member["geography.city"])

    states = sorted(set(states))
    cities = sorted(set(cities))
    agencies = sorted(set(agencies))
    years = sorted(set(years))
    months = sorted(set(months))

    # return [states, cities, agencies, years, months]
    return render_template('spending.html', states=states,
                                            cities=cities,
                                            agencies=agencies,
                                            years=years,
                                            months=months)



@app.route("/drilldown")
@app.route("/drilldown/<dim_name>")
def drilldown(dim_name=None):
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)
    result = browser.aggregate()
    # print('keys: ' + result.levels)

    if not dim_name:
        return render_template('drilldown.html', dimensions=cube.dimensions)

    dimension = cube.dimension(dim_name)
    hierarchy = dimension.hierarchy()

    cutstr = request.args.get("cut")
    page = int(request.args.get('page', 0))
    cell = cubes.Cell(browser.cube, cubes.cuts_from_string(cube, cutstr))

    cut = cell.cut_for_dimension(dimension)

    if cut:
        path = cut.path
    else:
        path = []

    result = browser.aggregate(cell, drilldown=[dim_name], page=page, page_size=10)

    if path:
        details = browser.cell_details(cell, dimension)[0]
    else:
        details = []

    levels = hierarchy.levels_for_path(path)
    if levels:
        next_level = hierarchy.next_level(levels[-1])
    else:
        next_level = hierarchy.next_level(None)

    is_last = hierarchy.is_last(next_level)

    pagination = Pagination(page=page, css_framework='foundation', total=result.total_cell_count, per_page=10)

    return render_template('drilldown.html',
                            dimensions=cube.dimensions,
                            dimension=dimension,
                            levels=levels,
                            next_level=next_level,
                            result=result,
                            cell=cell,
                            is_last=is_last,
                            details=details,
                            pagination=pagination
                            )


if __name__ == '__main__':

    # Create a Slicer and register it at http://localhost:5000/slicer
    app.register_blueprint(slicer, url_prefix="/slicer", config="slicer.ini")
    app.run(host="localhost", port=8000, debug=True)
