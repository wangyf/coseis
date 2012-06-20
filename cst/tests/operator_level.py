#!/usr/bin/env python

def test(argv=[]):
    """
    Test SORD operators
    """
    import os
    import numpy as np
    import cst
    prm = cst.sord.parameters()

    # parameters
    prm.debug = 0
    prm.itstats = 1
    prm.shape = 5, 4, 2, 2
    prm.delta = 100.0, 100.0, 100.0, 0.0075
    prm.bc1 = 0, 0, 0
    prm.bc2 = 0, 0, 0

    # source
    prm.source = 'potency'
    prm.ihypo = 1.5, 1.5, 1.5
    prm.ihypo = 3.0, 1.5, 1.5
    prm.source1 = 1e10, 1e10, 1e10
    prm.source2 =  0.0,  0.0,  0.0
    prm.pulse = 'delta'

    # material
    prm.hourglass = 1.0, 1.0
    prm.fieldio = [
        ('=', 'rho', [], 2670.0),
        ('=', 'vp',  [], 6000.0),
        ('=', 'vs',  [], 3464.0),
        ('=', 'gam', [], 0.3),
    ]

    # output
    for f in cst.sord.fieldnames.volume:
        prm.fieldio += [('=w', f, [], f + '.bin')]

    # master
    prm.nproc3 = 2, 1, 1
    prm.nproc3 = 1, 1, 1
    prm.oplevel = 5
    job = cst.sord.run(
        prm,
        run = 'exec',
        argv = argv,
        name = 'oplevel%s' % prm.oplevel,
        force = True,
        build_mpi = False,
    )

    # variations
    max_err_all_ = 0.0
    for i in 6,:
        prm.oplevel = i
        job1 = cst.sord.run(
            prm,
            run = 'exec',
            argv = argv,
            name = 'oplevel%s' % prm.oplevel,
            force = True,
            build_mpi = False,
        )
        max_err_ = 0.0
        for f in cst.sord.fieldnames.volume:
            f1 = os.path.join(job.rundir, '%s.bin' % f)
            f2 = os.path.join(job1.rundir, '%s.bin' % f)
            v1 = np.fromfile(f1, job.dtype)
            v2 = np.fromfile(f2, job.dtype)
            dv = v1 - v2
            e = np.abs(dv).max()
            if e:
                e = 0.5 * e / (np.abs(v1).max() + np.abs(v2).max())
                print('%s error: %s' % (f, e))
                max_err_ = max(max_err_, e)
        print('max error: ', max_err_)
        max_err_all_ = max(max_err_all_, max_err_)
    assert max_err_all_ == 0.0

# continue if command line
if __name__ == '__main__':
    import sys
    test(sys.argv[1:])

