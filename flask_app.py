from flask import Flask, render_template, url_for, request, make_response
from flask.ext.paginate import Pagination
import cubes
import os.path
from cubes.server import slicer, workspace
import sqlalchemy

#
# The Flask Application
#
app = Flask(__name__)

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

MODEL_PATH = os.path.join(APP_ROOT, "model.json")
DB_URL = "postgresql://richardbanyi:dpcu923@localhost:5432/usaspending"
CUBE_NAME = "spending"


@app.route('/')
def template_test():
    return render_template('template.html', my_string="Hello World")

@app.route("/drilldown")
@app.route("/drilldown/<dim_name>")
@app.route("/drilldown/<dim_name>/<int:page>")
def drilldown(dim_name=None, page=1):
    cube = workspace.cube(CUBE_NAME)
    browser = workspace.browser(cube)
    result = browser.aggregate()
    # print('keys: ' + result.levels)

    if not dim_name:
        return render_template('drilldown.html', dimensions=cube.dimensions)

    dimension = cube.dimension(dim_name)
    hierarchy = dimension.hierarchy()

    cutstr = request.args.get("cut")
    cell = cubes.Cell(browser.cube, cubes.cuts_from_string(cube, cutstr))

    cut = cell.cut_for_dimension(dimension)

    if cut:
        path = cut.path
    else:
        path = []

    # print("AGGREGATE %s DD: %s" % (cell, dim_name))
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

    labels = [detail["_label"] for detail in details]


    pagination = Pagination(page=page, css_framework='foundation', total=result.total_cell_count)

    return render_template('drilldown.html',
                            dimensions=cube.dimensions,
                            dimension=dimension,
                            levels=levels,
                            next_level=next_level,
                            result=result,
                            cell=cell,
                            is_last=is_last,
                            details=details,
                            pagination=pagination,
                            labels=labels)


if __name__ == '__main__':

    # Create a Slicer and register it at http://localhost:5000/slicer
    app.register_blueprint(slicer, url_prefix="/slicer", config="slicer.ini")
    app.run(debug=True)
