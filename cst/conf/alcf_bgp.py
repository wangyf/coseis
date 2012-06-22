"""
ALCF IBM Blue Gene/P

install location:
challenger.alcf.anl.gov:/intrepid-fs0/$USER/persistent

.softevnrc:
PYTHONPATH += $HOME/coseis
PATH += $HOME/coseis/bin
PATH += /gpfs/home/gely/local-$HOSTTYPE/bin
MANPATH += /gpfs/home/gely/local-$HOSTTYPE/man
PATH += /bgsys/drivers/ppcfloor/comm/xl/bin
+git-1.7.6.4
"""

# machine properties
maxcores = 4
maxram = 2048
host_opts = {
    'challenger': {'maxnodes': 512,   'maxtime': 60,  'queue': 'prod-devel'},
    'surveyor':   {'maxnodes': 1024,  'maxtime': 60,  'queue': 'default'},
    'intrepid':   {'maxnodes': 40960, 'maxtime': 720, 'queue': 'prod'},
}

# compilers
build_cc = 'mpixlcc_r -qlist -qreport -qsuppress=cmpmsg'
build_fc = 'mpixlf2003_r -qlist -qreport -qsuppress=cmpmsg'
build_ld = 'mpixlf2003_r'
build_libs = '/home/morozov/lib/libmpihpm.a'

# MPI
build_flags = '-g -O3'
ppn_range = [1, 2, 4]
nthread = 1
launch = 'cobalt-mpirun -mode vn -verbose 2 -np {nproc} {command}'

# MPI + OpenMP
build_flags = '-g -O0 -qsmp=omp -C -qlanglvl=2003pure'
build_flags = '-g -O3 -qsmp=omp -qrealsize=8'
build_flags = '-g -O3 -qsmp=omp'
ppn_range = [1]
nthread = 4
launch = 'cobalt-mpirun -mode smp -verbose 2 -np {nproc} -env OMP_NUM_THREADS={nthread} {command}'

# job submission
notify = '-M {email}'
submit = 'qsub {notify} -O {name} -A {account} -q {queue} -n {nodes} -t {minutes} --mode script {submit_flags} {name}.sh'
submit2 = 'qsub {notify} -O {name} -A {account} -q {queue} -n {nodes} -t {minutes} --mode script --dependenices {depend} {submit_flags} "{name}.sh"'
 
