# Coseis

### Computational Seismology Tools {#subtitle}

<nav>

- [Install](#install)
- [Examples](#examples)
- [SORD](SORD.html)
- [Code](https://github.com/gely/coseis/)

</nav>

## Summary

Coseis is an open-source toolkit for earthquake simulation featuring:

- The Support Operator Rupture Dynamics (SORD) code for modeling spontaneous
  rupture and 3D wave propagation.

- SCEC Community Velocity Models (CVM) codes, with MPI parallelization for
  [Magistrale version](http://www.data.scec.org/3Dvelocity/) (CVM-S), and new
  [geotechnical layer implementation](http://earth.usc.edu/~gely/vs30gtl/) for
  the [Harvard version](http://structure.harvard.edu/cvm-h/) (CVM-H).

- Utilities for mesh generation, coordinate projection, and visualization.

The primary interface is through a Python module which (for high-performance
components) wraps Fortran parallelized with hybrid OpenMP and MPI.

Coseis is written by [Geoffrey Ely] with contributions from Steven Day,
Bernard Minster, Feng Wang, Zheqiang Shi, and Jun Zhou.  It is licensed under
[BSD] terms.

[Geoffrey Ely]: http://earth.usc.edu/~gely/
[BSD]:          http://opensource.org/licenses/BSD-2-Clause

**WARNING**: Coseis is a research code under active development. Changes are
frequent and it has known bugs!


## Install

1.  If on Mac OS X, first install [Xcode] from the App Store. From the Xcode
    preferences pane, install the Command Line Tools. Then install [Homebrew],
    followed by [Git] and [Fortran] with::

        brew install git gfortran

    OpenMP is broken in GCC 4.3 on Lion, so if you need multiprocessing speed-up,
    install either [MPICH] or a newer [GCC] version.  Optionally, install and
    [Anaconda] for visualization and analysis. 

2.  Clone the source code from the [Coseis GitHub repository]
    (http://github.com/gely/coseis):

        git clone git://github.com/gely/coseis.git

3.  Set path variables for the Python module and executables. For bash shell,
    with the code located in your home directory (for example) add these lines
    to

        export PYTHONPATH="$HOME/coseis"
        export PATH="$PATH:$HOME/coseis/bin"

4.  Run the `setup.py` script to test your configuration. This will display
    all of the configuration parameters::

        python setup.py

5.  These parameters may be customized by creating a file `cst/conf/site.py`.
    For example, the account for billing of service units, and email address for
    notifications may be specified in `site.py` module with::

        account = 'your_project_name_here'
        email = 'your.email@address.here'

[Xcode]:    http://itunes.apple.com/us/app/xcode/id497799835
[Homebrew]: http://mxcl.github.com/homebrew/
[Git]:      http://git-scm.com/
[Fortran]:  http://r.research.att.com/tools/
[MPICH]:    http://www.mcs.anl.gov/research/projects/mpich2/
[GCC]:      http://gcc.gnu.org/
[Anaconda]: https://store.continuum.io/cshop/anaconda/


## Testing

To run the test suite interactively::

    cd cst/tests
    python test_runner.py --run=exec

Or, submit a job for batch processing::

    python test_runner.py --run=submit

After completion, a report is printed to the screen (or saved in
`run/test_suite/test_suite.output`)::

    PASSED: doctest.testmod(cst.util)
    PASSED: doctest.testmod(cst.coord)
    PASSED: doctest.testmod(cst.sord)
    PASSED: cst.tests.syntax.test()
    PASSED: cst.tests.configure.test()
    PASSED: cst.tests.hello_mpi.test()
    PASSED: cst.tests.point_source.test()
    PASSED: cst.tests.pml_boundary.test()
    PASSED: cst.tests.kostrov.test()


## Examples

### CVM depth plane

![](../figures/CVM-Slice-Vs-S.png)

![](../figures/CVM-Slice-Vs-H.png)

Extract S-wave velocity at 500 meters depth. Plot using Matplotlib:

[CVM-Slice.py](../scripts/CVM-Slice.py)

### CVM-S fence diagram

![](../figures/CVM-Fence-Vp-S.png)

Build a fence diagram similar to Magistrale (2000) figure 10. Plot using
Mayavi

[CVM-Fence.py](../scripts/CVM-Fence.py)

### CVM-S basin depth

![](../figures/CVM-Basins.png)

Extract 3D mesh and search for the shallowest surface of Vs = 2.5 km/s. Plot
over topography using Mayavi.

[CVM-Basins-mesh.py](../scripts/CVM-Basins-mesh.py)  
[CVM-Basins-search.py](../scripts/CVM-Basins-search.py)  
[CVM-Basins-plot.py](../scripts/CVM-Basins-plot.py)  

