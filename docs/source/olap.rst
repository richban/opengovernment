OLAP
====

The presentation area is based on online analytic processing (OLAP) technology, the data is stored in cubes.

Cubes - OLAP Framework
----------------------

Cubes is a light-weight Python framework and set of tools for development of reporting and analytical applications,
Online Analytical Processing (OLAP), multidimensional analysis and browsing of aggregated data [Cubes]_.

.. [Cubes] Author: Stefan Urbanek
           Availailable: `Cubes Overview <cubes.readthedocs.io/en/v1.0.1/#>`_

The framework models the data as a cube with multiple dimensions:


.. figure:: images/cube-dims_and_cell.png
   :scale: 100 %

   Cubes Dimension and Cell

Core cube features that we have implemented:

* **Workspace** - Cubes analytical workspace

* **Model** - Description of data (metadata): cubes, dimensions, hierarchies, attributes, labels etc.

* **Browser** - Aggregation browsing, slicing-and-dicing, drill-down.

* **Backend** - built-in ROLAP backend which uses Postgres SQL database using SQLAlchemy.

* **Server** - WSGI HTTP server for Cubes

Analytical Workspace
--------------------

Everything in Cubes happens in an analytical workspace. It contains cubes, maintains connections to the data stores
(with cube data), provides connection to external cubes and more [workspace]_.

.. [workspace] Author: Stefan Urbanek
               Availailable: `Cubes Analytical Workspace <cubes.readthedocs.io/en/v1.0.1/tutorial.html>`_

.. figure:: images/cubes-workspace_simplified-2.png
   :scale: 100 %

   Cubes Workspace

The workspace properties are specified in a configuration file *slicer.ini*.
First we have specified the workspace - cubes workspace configuration.
We have provided the workspace our *model.json* metadata dictionary. We have added a logging
path where to log file for better understanding of debug logs.

.. code-block:: python
   :caption: slicer.ini
   :name: Workspace Configuration

   [workspace]
   log: error.log
   log_lever: debug
   model: model.json

For the server section we have defined the HTTP WSGI OLAP Server.
The host where the server runs. Port on which the the server listens.
We have allowed Cross-origin resource sharing header for the CubesViewer.

.. code-block:: python
   :caption: slicer.ini
   :name: Server Configuration

   [server]
   host: localhost
   port: 5000
   prettyprint: true
   reload: true
   allow_cors_origin: http://localhost:8000

We have specified our data store - the database containing the cube’s data.
We have defined the prefix for dimension *dm_* and for fact *ft_* this allows the
mapper to find dimension and fact tables in the database.

.. code-block:: python
   :caption: slicer.ini
   :name: Store Configuration

   [store]
   type: sql
   url: postgresql://richardbanyi:dpcu923@localhost:5432/usaspending
   fact_prefix: ft_
   dimension_prefix: dm_
   debug: true

The model section contains list of models. We have defined only one model.

.. code-block:: python
   :caption: slicer.ini
   :name: List of Models

   [models]
   main: model.json


Logical Model and Metadata
--------------------------

Logical model describes the data from user’s or analyst’s perspective: data how they are being measured,
aggregated and reported. Model is independent of physical implementation of data. This physical
independence makes it easier to focus on data instead on ways of how to get the data in understandable form [model]_.


.. [model] Author: Stefan Urbanek
           Availailable: `Cubes Model <cubes.readthedocs.io/en/v1.0.1/model.html>`_

Analyst or report writers, anyone who will access the web application do not have to know where name
of an government organisation or recipient name is stored, nor do they have to know where is data stored
they only ask for *agency.name* or *recipient.name*.

Example: User wants to find out the award amounts by geography which has four levels:country level, state level,
city level and zip level. The original data is stored in the physical database in the geography table. User doesn’t
have to know where the data are stored, he just queries for the geography.state and geography.city and will get the proper data.

.. figure:: images/logical-to-physical.png
   :scale: 100 %

   Logical to Physical Mapping

Model
-----

The logical model is described using model metadata dictionary. The content is description of logical objects,
physical storage and other additional information [model2]_.

.. [model2] Author: Stefan Urbanek
           Availailable: `Cubes  Model metadata <cubes.readthedocs.io/en/v1.0.1/model.html>`_

.. figure:: images/cubes-model_metadata.png
   :scale: 100 %

   Cubes - Model Metadata

.. code-block:: javascript
   :caption: Model Example
   :name: Model Metadata

   {
       "name": "usaspending",
       "label": "Federal Award Transactions",
       "description": "Federal Award Transactions of United States of America"
       "cubes": [...]
       "dimensions": [...]
   }

In our case the logical part of the model description consists of the following attributes:
**Name** is the name of our model, **label** and **descriptions** is used for human readable label/descriptions
it’s optional. **Cubes** is a list of cubes metadata, we have defined only one cube for our case study spending.
**Dimensions** is a list of dimension metadata.

The physical part of the model description consists of the following attributes:

**Joins** we have only specified backend join specification, it is used to match joins in the cube.

Cubes
"""""

Cube descriptions are stored as a dictionary for key *cubes*.

.. code-block:: javascript
   :caption: Cubes Example
   :name: Cubes Metadata

   {
       "name": "usaspending",
       "label": “Federal Award Transactions",
       "dimensions": [ "date", ... ],
       "measures": [...],
       "aggregates": [...],
       "details": [...],
   }



Measures and Aggregates
"""""""""""""""""""""""

.. figure:: images/cubes-measure_vs_aggregate.png
   :scale: 80 %

   Cubes - Measures vs. Aggreates

The measure is numerical property of a fact. It represent the award_amount column in the physical model.

.. code-block:: javascript
   :caption: Measures
   :name: Measures

   "measures": [
      { "name": "award_amount" , "label": "Award amount"}
    ]

Aggregates is a list of aggregates that we have provided for the measure.

.. code-block:: javascript
   :caption: Aggregates
   :name: List of Aggregates

    "aggregates":  [
      {
          "name": "award_sum",
          "label": "Total Award Amount",
          "function": "sum",
          "measure": "award_amount"
      },
      {
          "name": "transaction_count",
          "label": "Total Transactions",
          "function": "count"
      },
      {
          "name": "award_min",
          "label": "Min Amount",
          "measure": "award_amount",
          "function": "min"
      },
      {
          "name": "award_max",
          "label": "Max Amount",
          "measure": "award_amount",
          "function": "max"
      }
    ]

Note that item_count aggregate - it counts number of the facts within the cell. No measure required
as a source for the aggregate. It helps to count the number of the transactions.

Mappings
""""""""

The most important part of the OLAP on top of the start schema is mapping of the logical
attributes to their physical attributes. In SQL database the physical attributes are stored in columns,
which belongs to tables, which are part of the starcshema.

.. figure:: images/mapping_logical_to_physical.png
   :scale: 80 %

   Cubes - Mapping Logical to Physical

Example:

For data browsing, we have defined mappings, so that Cubes framework has know where logical attributes are physically stored.
With this the Cubes framework know which tables are related to the cube spending and how they are joined together.

The are two ways how the mapping is being done:
* Imlicit
* Explicit

We have chosen the implicit declarations which has been most straightforward and simple.
With implicit mapping we have matched a database schema with logical model and have avoided additional specific mapping metadata.

This is how it would looked like if we would have chosen explicit mappings:

.. code-block:: javascript
   :caption: Explicit Mapping
   :name: Explicit Mapping

   "mappings": {
      "product.name": "dm_products.product_name"
   }

The mapping process look like this:

.. figure:: images/mapping-overview.png
   :scale: 80 %

   Cubes - Mapping Overview



Facts
"""""

Cubes looks for fact table with the same name as cube name. We have specified prefix for every fact table with 
*ft_* in the workspace configuration *slicer.ini*.

* Cube is named *spending*: the framework looks for a fact table named *spending*.
* **fact table name = fact table prefix + fact table name**

Dimensions
""""""""""

Same as for fact tables cubes looks for dimension table with the same name as dimension name.
We have specified prefix for every dimension table with *dm_* in the workspace configuration *slicer.ini*.
We have design our dimension columns to have the same name as dimension attributes.


.. figure:: images/dimension_attribute_prefix_map.png
   :scale: 100 %

   Cubes - Dimension attribute prefix

* **dimension table name = dimension prefix + dimension name**

An example of product dimension:

.. code-block:: javascript
   :caption: Product dimension
   :name: Product Dimension

    {
      "name": "product",
      "label": "Product",
      "attributes": [
          { "name": "id" },
          { "name": "product_name" }
      ],
      "levels": [ ... ],
      "hierarchies": [ ... ]
    }


Joins
"""""

Tables are joined by matching single-column - surrogate keys.
Joins are defined as an ordered list. We had to define the column reference for both master
table and a table with details. The order of joins has to be from master to detail.

.. code-block:: javascript
   :caption: Join example
   :name: Join

    "joins":  [
        {
            "master": "date_id",
            "detail": "dm_date.id"
        },
    ]

Cubes supports three join methods *match, detail and master*.

*match* (default) – the keys from both master and detail tables have to match – INNER JOIN

.. figure:: images/cubes-sql_joins-match.png
   :scale: 100 %

   Cubes - Join Match

Hierarchies and Levels
""""""""""""""""""""""

Dimensions can have more than one level. Date dimension has 8 levels. Which every of these levels has it’s own attributes.
The month level is represented by two attributes month an integer data type which describes the mont of the year and
second attribute month name.

.. code-block:: javascript
   :caption: Levels - Month
   :name: Month Level

    "levels":  [
        {
            "name": "month",
            "label": "Month",
            "key": "month",
            "label_attribute": "month_name",
            "attributes":  [
                { "name": "month" },
                { "name": "month_name" }
            ]
        }

For date dimension we have created multiple ways of organising attributes into hierarchies.
The date can be composed of *year-month-day* or *year-quarter-month-day*.
We have defined four different hierarchies.

First we have defined all possible level.s Then created list of hierarchies where we specified
order of the levels for the particularly hierarchy.

.. code-block:: javascript
   :caption: Hierarchies - Year-Month-day
   :name: ymd

    "hierarchies":  [
        {
            "name": "ymd",
            "label": "Y-M-D",
            "levels": ["year", "month", "day"]
        }
    ]

User-oriented Metadata
""""""""""""""""""""""

For a better understanding to users we have added labels for parts of the model that are being displayed to the users.
They are used for report tables as column headings or as a filter of description. We have specified them for
every object model (cube, dimension, level, attribute etc.) with the label attribute. The *key* attribute is used
for filtering and *label_attribute* is used for the data to be displayed in the user interface (labels).

.. code-block:: javascript
   :caption: Labels
   :name: Labels

    "levels":  [
        {
            "name": "month",
            "label": "Month",
            "key": "month",
            "label_attribute": "month_name",
            "attributes":  [
                { "name": "month" },
                { "name": "month_name" }
            ]
        }


.. figure:: images/schema-label_attributes.png
   :scale: 100 %

   Cubes - Labels

Slicing and Dicing
------------------

Browser
"""""""

The aggregation, slicing, dicing, browsing of the multi-dimensional data is being done by an AggregationBrowser.

.. code-block:: python
   :caption: Workspace & Browser initilization
   :name: Workspace & Browser

   from cubes import Workspace

   workspace = Workspace("slicer.ini")
   browser = workspace.browser()

Here we initialised our workspace, and create and initialises the aggregation browser.

.. figure:: images/browser-package.png
   :scale: 80 %

   Cubes - Browser aggregate

Cells and Cuts
""""""""""""""

Cell defines a point of interest – portion of the cube to be aggergated or browsed.

.. figure:: images/cubes-slice_and_dice-cell.png
   :scale: 80 %

   Cubes - Slice and Dice cell

There are three types of cells: point – defines a single point in a dimension at a
particular level; range – defines all points of an ordered dimension (such as date)
within the range and set – collection of points [cells]_.

.. [cells] Author: Stefan Urbanek
           Availailable: `Slicing and Dicing <cubes.readthedocs.io/en/v1.0.1/slicing_and_dicing.html>`_

.. figure:: images/cubes-point-range-set-cut.png
   :scale: 100 %

   Cubes - Cuts

Points are defined as dimension paths – list of dimension level keys. For example a date path for
3rd of June 2015 would be: [2015, 6, 3]. For the month June it would be [2015, 6]
and for the whole year of 2015 it would be [2015].
In python the cuts for “transactions from June of 2010 to June of 2012 for geography United States of America” are defined as:

.. code-block:: python
   :caption: Point cut example
   :name: Point cuts

   cuts = [
      PointCut("geography", ["united states of america"]),
      PointCut("date", [2010, 6], [2012, 6])
      ]

A range might look like this:

.. code-block:: python
   :caption: Range cut example
   :name: Range cuts

   cuts = [
       PointCut("date", [2010], [2012, 12, 24])
   ]

Aggregate
"""""""""

Aggregate of a cell:

.. code-block:: python
   :caption: Aggregate of a Cell
   :name: Cell aggregate

    cuts = [
        PointCut("geography", ["sk"])
        PointCut("date", [2010, 6], [2012, 6]),
    ]
    cell = Cell(cube, cuts)
    result = browser.aggregate(cell)

We have a situation when a different hierarchy is desired than the default, so we have defined the hierarchy we wanted:

.. code-block:: python
   :caption: Aggregate of a Cell with hierarchy
   :name: Cell hierachy

    cuts = [
        PointCut("date", [2010, 2], [2012, 2], hierarchy="yqmd")
    ]

Drilldown
"""""""""

Drill-down – get more details, group the aggregation by dimension members.
For example:

.. code-block:: python
   :caption: Drilldown
   :name: Drilldown

   cut = PointCut("date", [2010])
   cell = Cell(cube, [cut])
   result = browser.aggregate(cell, drilldown=['date'])


**Implicit**

The way we are drilling down, is that cubes knows the next level of the drilled dimension.
We have stated that our geography dimension has 4 levels: country, state, city, zip. This
means that the first level of the dimension is country. The “next level” is determined as the next
level after the deepest level used in a cut. The next level is by state, and so on. If the cut is at
its deepest level (zip), it is not possible to to drill-down deeper.

**Explicit**

For explicit drilling down, the cut is not considered for the drill down level. We have just implicitly declared the drill-down levels.


Drill Down Tree
---------------

We have created a function that traverse a dimension hierarchy and print-out aggregations
(count of transactions and award amounts) at the actual browsed location.

Attributes:

* dimension - dimension to be traversed trough all levels.

.. code-block:: python

   def drilldown(dim_name=None):

First we need to get the dimension hierarchy to know the order of levels. Most dimensions have only one hierarchy, thought.

.. code-block:: python

   dimension = cube.dimension(dim_name)
   hierarchy = dimension.hierarchy()


Parser the cut request parameter and convert it to a list of actual cube cuts.

.. code-block:: python

   cutstr = request.args.get("cut")
   hierarchy = dimension.hierarchy()
   cell = cubes.Cell(browser.cube, cubes.cuts_from_string(cube, cutstr))

We get the cut of actually browsed dimension, so we know “where we are”.

.. code-block:: python

    cut = cell.cut_for_dimension(dimension)

    if cut:
        path = cut.path
    else:
        path = []

Now we do the actual aggregation of the cell.

.. code-block:: python

    levels = hierarchy.levels_for_path(path)
    if levels:
        next_level = hierarchy.next_level(levels[-1])
    else:
        next_level = hierarchy.next_level(None)

We have created a flag, so that we know that we are at the deepest level.

.. code-block:: python

   is_last = hierarchy.is_last(next_level)


And finally we, render the template

.. code-block:: python

    return render_template('drilldown.html', dimensions=cube.dimensions, dimension=dimension,
                            levels=levels, next_level=next_level, result=result,
                            cell=cell, is_last=is_last, details=details, pagination=pagination
                            )


Web Application
===============

.. figure:: images/website.png
   :scale: 80 %

   Opengovernment - web application

The final major component of the implementation environment is the web application.
We have build a web application that provide variety of capabilities to general users to leverage
the presentation area for analytical decision making.

For the web development of the application we have used a micro web development framework for Python called Flask.
For the front end we have used bootstrap framework to design the layouts and the interface. We are also relying
on some  javascript libraries for the charts.

The open government folder is where we have dropped our files. We have put directly in this folder our
data warehouse schema, models for cubes, as well as the main application module. The static folder is a
place where we have placed css, javascript files. Inside the templates folder the application looks for the templates.

.. code-block:: python

   /opengovernment
      /static
      /templates
      /postgres
      /models
      flask_app.py



The actual application module, we have named it flask_app.py is the core of the back end.
This is where the all web development functions are implemented. We have integrated Cubes Slicer
Server with the application to provide raw analytical data. We have provided Slicer as a flask Blueprint
to the application - a module that is plugged in.

.. code-block:: python

  if __name__ == '__main__':

      # Create a Slicer and register it at http://localhost:5000/slicer
      app.register_blueprint(slicer, url_prefix="/slicer", config="slicer.ini")
      app.run(host="localhost", port=8000, debug=True)

We have implemented the following 7 features in our web application:

* **Spending** - A good place to start to find information about federal funding.
  On Spending Page users just have to input a zip code which they are interested in and
  see all the federal transactions in their backyard. They can also see the transactions throughout state,
  county, as well as by federal agency and award type.

* **Dashboard** - On Dashboard Page we enabled users to drill down from one place to another,
  they will find information to detailed data by focusing on something. For example to drill down through
  a series of place where the work was/is performed.

* **Reports** - We have implemented a visual tool for exploring and analysing our OLAP Cube.
  We  have enabled users to explore data, create their own reports. It enables data exploration,
  data auditory, generation of reports, chart design and simple analytics.

* **Charts** - We have also created our own charts using javascript libraries.
  On Chart pages users can drill down/roll up donut charts. Or they can look at Agencies
  Profile to see the total amount of money an agency awarded or State Summary to find out
  the total dollar amount for federal transactions for cities where the money was distributed.


