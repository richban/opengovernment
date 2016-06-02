Appendix A
==========

******************
Instalation Manual
******************

In this section of appendinx, user guide to setting up the environment and installation is described.
This sections covers all the pre-requireties and procedures for demonstration of the bachelor thesis.

Python
******

Before we start, we will need Python on your computer, but you may not need to download it.
First of all check that you don't already have Python installed by entering python in a command line window.
If you see a response from a Python interpreter it will include a version number in its initial display.

.. code-block:: bash
   :caption: Python in command line
   :name: Python in command line

   Python 3.4.3 (v3.4.3:9b73f1c3e601, Feb 23 2015, 02:52:03)
   [GCC 4.2.1 (Apple Inc. build 5666) (dot 3)] on darwin
   Type "help", "copyright", "credits" or "license" for more information.
   >>>

If you need to install Python, you may as well download the most recent stable version Python 3.

**If you're running Windows:** the most stable Windows downloads are available from the `https://www.python.org/downloads/windows/`.

**If you are using a Mac:** see the `https://www.python.org/downloads/windows/`.

**For Debian or Ubuntu:** For Debian or Ubuntu, install the python3.x and python3.x-dev packages

Install Packages
****************

This section covers the basics of how to install Python packages (i.e. a bundle of software to be installed).

If you have Python 3 >=3.4 installed from python.org, you will already have pip and setuptools,
but will need to upgrade to the latest version.

On Linux or OS X:

.. code-block:: bash
   :caption: Pip install
   :name: Pip install

   pip install -U

On Windows:

.. code-block:: bash
   :caption: Pip install on Windows
   :name: Pip install on Windows

   python -m pip install

Creating Virtual Environments
*****************************

Python “Virtual Environments” allow Python packages to be installed in an isolated location for
a particular application, rather than being installed globally.

The basic commands:

.. code-block:: bash
   :caption: Creating Virtual Environment
   :name: Creating Virtual Environment

   pip install virtualenv
   virtualenv <DIR>
   source <DIR>/bin/activate


PostgreSQL
**********

PostgreSQL is an object-relational database management system (ORDBMS).
It supports a large part of the SQL standard and offers many modern features.

**For Windows distribution:** `http://www.enterprisedb.com/products-services-training/pgdownload`

After downloading the source installation just simple run the setup.exe and follow the instructions.

**For OS X distribution:** `http://postgresapp.com`

For MAC OS X we recommend to download Postgres.app which is a simple application that runs a menubar without the need of any installation.


Cubes
*****

You may install Cubes with the minimal dependencies:

.. code-block:: bash
   :caption: Install Cubes
   :name: Install Cubes

   pip install cubes

The cubes has optional requirements:

* **SQLAlchemy** for SQL database
* **Flask** for Slicer OLAP HTTP server

To install these requirements:

.. code-block:: bash
   :caption: Cubes requirements
   :name: Cubes requirements

   pip install Flask SQLAlchemy

There is also a customized installation with requirements:

.. code-block:: bash
   :caption: Customized installation
   :name: Customized installation


   pip install python-dateutil jsonschema expressions grako click

To run Cubes OLAP HTTP server:

.. code-block:: bash
   :caption: OLAP HTTP server
   :name: OLAP HTTP server

   slicer serve slicer.ini

And try to do some queries:

.. code-block:: bash
   :caption: OLAP HTTP server
   :name: OLAP HTTP server

   curl "http://localhost:5000/cube/spending/aggregate"
   curl "http://localhost:5000/cube/spending/aggregate?drilldown=year"
   curl "http://localhost:5000/cube/spending/aggregate?drilldown=country"


Flask
*****

In order to run the web application you have install Flask which is a micro
webdevelopment framework for Python.

Enter the following command to get Flask activated in your virtualenv

.. code-block:: bash
   :caption: Install Flask
   :name: Install Flask

   pip install Flask


Flask depends on two external libraries Werkzeug and Jinja2.
The web application depends also on other external packages. For successfuly running the application
install the following packages

.. code-block:: bash
   :caption: Install external packages
   :name: Install external packages

   pip install Werkzeug jinja2 Flask-WTF


Web application
***************

After all these installations, you should be able to run the application. Now just copy the *opengovernment* folder,
which is located on the DVD, into your home directory of your virtual environment.
Open the *postgres* folder and run the following command to load the data into database

.. code-block:: sql
   :caption: Load Data
   :name: Load Data

   pg_restore -Fc -C pg_dump.gz

Move up to folder *opengovernment*. Run the Cubes OLAP HTTP server.

.. code-block:: bash
   :caption: OLAP HTTP server
   :name: OLAP HTTP server

   slicer serve slicer.ini

Now run the actual Flask application *flask_app.py*

.. code-block:: bash
   :caption: Run Flask App
   :name: Run Flask App

   python flask_app.py
