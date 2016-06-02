Conclusion
==========

The bachelor thesis was aimed to implement an open-data data warehouse using open government data.
As we have been started through searching for data, we have studied the metadata of the source, the
process in detail and observe the transactions of government institutes, such as contracts, grants,
loans and other financial assistance, we have decided that the federal award transaction is thebusiness process to be modelled.

Once the business model has been identified, we faced a serious decision about the granularity of the data warehouse.
We ensured maximum dimensionality and flexibility by choosing the most granular data - individual transactions made by federal agencies.
After we have declared the grain of the fact table, the dimensions fall out immediately.

We have made various transformations on data to enforce data quality, integrity and consistency, conformed data so 
that separate flat files can be used together, and delivered data into the presentation layer.

Then, we have designed the multidimensional model of the presentation layer, which is based on online analytic processing
(OLAP) technology, so that the data is stored in cubes. We have properly specified the analytical workspace of the Cubes.
Following we have provided logical model metadata to the workspace.

Finally, the major component of the the implementation was to make it accessible and available to the end users.
For this reason, we have build a web application using a micro web development framework for Python called Flask.
We have implemented various features for the end users. Visual tool for exploring and analysis, which enables data
exploration, data auditory, generation of reports, chart design and simple analytics. By this we have enabled the 
general public to evaluate the business process of the government.
