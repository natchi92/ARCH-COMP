'''
Building Example in Hylaa-Continuous
'''

import numpy as np
from scipy.io import loadmat
from scipy.sparse import csr_matrix, csc_matrix

from hylaa.hybrid_automaton import LinearHybridAutomaton, bounds_list_to_init
from hylaa.engine import HylaaSettings
from hylaa.engine import HylaaEngine
from hylaa.settings import PlotSettings, TimeElapseSettings
from hylaa.star import Star

def define_ha(spec, limit, uncertain_inputs):
    '''make the hybrid automaton and return it'''

    ha = LinearHybridAutomaton()

    mode = ha.new_mode('mode')
    dynamics = loadmat('build.mat')
    a_matrix = dynamics['A']
    n = a_matrix.shape[0]
    b_matrix = csc_matrix(dynamics['B'])

    if uncertain_inputs:
        mode.set_dynamics(csr_matrix(a_matrix))

        # 0 <= u1 <= 0.1
        bounds_list = [(0.8, 1.0)]
        _, u_mat, u_rhs, u_range_tuples = bounds_list_to_init(bounds_list)

        mode.set_inputs(b_matrix, u_mat, u_rhs, u_range_tuples)
    else:
        # add the input as a state variable
        big_a_mat = np.zeros((n+1, n+1))
        big_a_mat[0:n, 0:n] = a_matrix.toarray()
        big_a_mat[0:n, n:n+1] = b_matrix.toarray()
        a_matrix = big_a_mat

        mode.set_dynamics(csr_matrix(big_a_mat))

    error = ha.new_mode('error')

    y1 = dynamics['C'][0]

    if not uncertain_inputs:
        new_y1 = np.zeros((1, n+1))
        new_y1[0, 0:n] = y1
        y1 = new_y1

    output_space = csr_matrix(y1)

    mode.set_output_space(output_space)

    trans1 = ha.new_transition(mode, error)
    mat = csr_matrix(([-1], [0], [0, 1]), dtype=float, shape=(1, 1))
    rhs = np.array([-limit], dtype=float) # safe
    trans1.set_guard(mat, rhs) # y3 >= limit

    return ha

def make_init_star(ha, hylaa_settings):
    '''returns a star'''

    bounds_list = []
    dims = ha.modes.values()[0].a_matrix_csr.shape[0]

    for dim in xrange(dims):
        if dim < 10:
            bounds_list.append((0.0002, 0.00025))
        elif dim == 25:
            bounds_list.append((-0.0001, 0.0001))
        elif dim == 48: # affine input effects term
            bounds_list.append((0.8, 1.0))
        else:
            bounds_list.append((0.0, 0.0))

    init_space, init_mat, init_mat_rhs, init_range_tuples = bounds_list_to_init(bounds_list)

    return Star(hylaa_settings, ha.modes['mode'], init_space, init_mat, init_mat_rhs, \
                init_range_tuples=init_range_tuples)

def define_settings(ha, limit):
    'get the hylaa settings object'
    plot_settings = PlotSettings()

    max_time = 20.0 # 20.0
    step_size = 0.005 # 0.005
    settings = HylaaSettings(step=step_size, max_time=max_time, plot_settings=plot_settings)
    settings.print_output = False

    return settings

def run_hylaa(spec='S01', uncertain_inputs=True):
    'Runs hylaa with the given settings, returning the HylaaResult object.'

    if spec == 'S01':
        limit = 0.0051
    elif spec == 'U01':
        limit = 0.004
    else:
        raise RuntimeError("Unsupported spec {}".format(spec))

    ha = define_ha(spec, limit, uncertain_inputs)
    settings = define_settings(ha, limit)
    init = make_init_star(ha, settings)

    engine = HylaaEngine(ha, settings)
    engine.run(init)

    return engine.result

if __name__ == '__main__':
    c01_s01 = run_hylaa(spec='S01', uncertain_inputs=False)
    print "Model C01, Spec S01, Time {:.2f} sec, safe={}".format(c01_s01.top_level_timer.total_secs, c01_s01.safe)

    f01_s01 = run_hylaa(spec='S01', uncertain_inputs=True)
    print "Model F01, Spec S01, Time {:.2f} sec, safe={}".format(f01_s01.top_level_timer.total_secs, f01_s01.safe)

    c01_u01 = run_hylaa(spec='U01', uncertain_inputs=False)
    print "Model C01, Spec U01, Time {:.2f} sec, safe={}".format(c01_u01.top_level_timer.total_secs, c01_u01.safe)

    f01_u01 = run_hylaa(spec='U01', uncertain_inputs=True)
    print "Model F01, Spec U01, Time {:.2f} sec, safe={}".format(f01_u01.top_level_timer.total_secs, f01_u01.safe)

