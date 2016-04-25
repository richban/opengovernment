from flask import Flask, render_template, url_for, request, make_response
from flask.ext.paginate import Pagination
from flask import Blueprint
import cubes
import os.path
from cubes.server import slicer, workspace
import sqlalchemy
from cubes import PointCut

#
# The Flask Application
#
app = Flask(__name__)

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

MODEL_PATH = os.path.join(APP_ROOT, "model.json")
DB_URL = "postgresql://richardbanyi:dpcu923@localhost:5432/usaspending"
CUBE_NAME = "spending"


@app.route("/")
def template_test():
    return render_template('template.html', my_string="Hello World")


@app.route("/spending/all", methods=['GET', 'POST'])
def all():
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)

    # states, cities, agencies, years, months = spending()

    if request.method == 'POST':
        if request.form['submit'] == 'reset':
            geo_cut = PointCut("geography", ["usa"])
            cell = cubes.Cell(browser.cube, [geo_cut])

            page = int(request.args.get('page', 0))

            result = browser.aggregate(cell, drilldown=["recipient"], page=page, page_size=10)

            pagination = Pagination(page=page, css_framework='foundation', total=result.total_cell_count, per_page=10)

            return render_template('all.html', result=result,
                                                pagination=pagination)
        if request.form['submit'] == 'go':
            cuts = []
            if request.form['year'] != "View All":
                if request.form['month'] != "View All":
                    cuts.append(PointCut("date", [int(request.form["year"]),
                                                    int(request.form["month"])]))
                else:
                    cuts.append(PointCut("date", [int(request.form["year"])]))
            if request.form["state"] != "View All":
                if request.form["city"] != "View All":
                    cuts.append(PointCut("geography", [request.form["state"],
                                                    request.form["city"]]))
                else:
                    cuts.append(PointCut("state", [request.form["state"]]))

            cell = cubes.Cell(browser.cube, cuts)
            page = int(request.args.get('page', 0))
            result = browser.aggregate(cell, drilldown=["recipient"], page=page, page_size=10)
            pagination = Pagination(page=page, css_framework='foundation', total=result.total_cell_count, per_page=10)

            return render_template('all.html', result=result,
                                                pagination=pagination)


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
    app.run(debug=True)
