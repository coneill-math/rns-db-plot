# rns-db-plot
Written by Christopher O'Neill and Zachary Spaulding.  

Provides a collection of [GAP](http://www.gap-system.org/) code for creating a database of random numerical semigroups and [Sage](http://sagemath.org/) code for plotting expected values.  The package was developed as part of a senior thesis project by Zachary Spaulding, an undergraduate student at University of California Davis.  For a more detailed overview, see [Zachary's senior thesis](https://www.math.ucdavis.edu/files/5815/2903/7838/s18-spaulding-zachary-thesis.pdf).  

You can find action shots in the `images` folder.  

Please note that this is an *alpha version* and subject to change without notice.  

## License
rns-db-plot is released under the terms of the [MIT license](https://tldrlegal.com/license/mit-license).  The MIT License is simple and easy to understand and it places almost no restrictions on what you can do with this software.

## Usage
Here we will walk through an example of running a small experiment using rns-db-plot.  This example used the function `RunExperimentPM()` which calls `RunExperimentP()` for each entry in a list of `M` values. We first launch GAP and run the following.

	gap> LoadPackage("num");
	gap> NumSgpsUse4ti2();
	gap> NumSgpsUse4ti2gap();
	gap> NumSgpsUseSingular();
	gap> NumSgpsUseNormaliz();
	gap> RunExperimentPM(1000, "file2.txt", "table\_2", [["NumMinGens", NumMinGens, "integer"]], [500, 1000, 5000, 10000], 1, 100, 1, 10, 15, GenerateNumericalSemigroupAp);
	gap> quit;

Next, run the following in the terminal to create the sqlite database.  

	~ $ sqlite3 Database
	sqlite> .read file_2.txt
	sqlite> .save Database
	sqlite> .quit

Finally, launch Sage and execute the following to generate the plots from this experiment.

	sage: import sqlite3
	sage: expectedAttributePlot("~/zacharyspaulding/NumSgps/Database", "table_2", "NumMinGens", [500, 1000, 5000, 10000])
