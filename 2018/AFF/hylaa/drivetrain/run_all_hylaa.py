'''Script for running drivetrain benchmark for hylaa in ARCHCOMP 2018'''

# make sure hybridpy is on your PYTHONPATH: hyst/src/hybridpy
import hybridpy.hypy as hypy

def main():
    '''main entry point'''

    runtimes = []
    safes = []
    thetas = [2, 22]
    scales = [1.0, 0.3, 0.05]

    for theta in thetas:
        for scale_init in scales:
            runtime, safe = run_drivetrain(theta, scale_init)
            runtimes.append(runtime)
            safes.append(safe)

            print "Runtime: {}".format(runtime)

    # print result summary
    index = 0

    for theta in thetas:
        for scale_init in scales:
            print "Theta = {}, Scale_init = {}, Safe={}, Runtime = {}".format(
                theta, scale_init, safes[index], runtimes[index])
            index += 1

def run_drivetrain(theta, scale_init=1.0):
    'generate a drivetrain benchmark instance, run it and return the runtime'

    title = "Drivetrain (Theta={}, InitScale={})".format(theta, scale_init)
    output_path = "hylaa_drivetrain_theta{}_initscale{}.py".format(theta, str(scale_init).replace(".", "_"))
    gen_param = '-theta {} -init_scale {} -reverse_errors -switch_time 0.20001'.format(theta, scale_init)

    e = hypy.Engine('hylaa')
    e.set_generator('drivetrain', gen_param)
    e.set_output(output_path)

    e.add_pass("sub_constants", "")
    e.add_pass("simplify", "-p")

    print 'Running ' + title
    res = e.run(print_stdout=False, parse_output=True)
    print 'Finished ' + title

    if res['code'] != hypy.Engine.SUCCESS:
        raise RuntimeError('Error generating ' + title + ': ' + str(res['code']))

    runtime = res['tool_time']
    safe = res['output']['safe']

    return runtime, safe

if __name__ == '__main__':
    main()
