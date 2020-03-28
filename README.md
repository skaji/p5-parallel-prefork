# NAME

Parallel::Prefork - A simple prefork server framework

# SYNOPSIS

    use Parallel::Prefork;
    
    my $pm = Parallel::Prefork->new({
      max_workers  => 10,
      trap_signals => {
        TERM => 'TERM',
        HUP  => 'TERM',
        USR1 => undef,
      }
    });
    
    while ($pm->signal_received ne 'TERM') {
      load_config();
      $pm->start(sub {
          ... do some work within the child process ...
      });
    }
    
    $pm->wait_all_children();

# DESCRIPTION

`Parallel::Prefork` is much like `Parallel::ForkManager`, but supports graceful shutdown and run-time reconfiguration.

# METHODS

## new

instantiation.  Takes a hashref as an argument.  Recognized attributes are as follows.

### max\_workers

number of worker processes (default: 10)

### spawn\_interval

interval in seconds between spawning child processes unless a child process exits abnormally (default: 0)

### err\_respawn\_interval

number of seconds to deter spawning of child processes after a worker exits abnormally (default: 1)

### trap\_signals

hashref of signals to be trapped.  Manager process will trap the signals listed in the keys of the hash, and send the signal specified in the associated value (if any) to all worker processes.  If the associated value is a scalar then it is treated as the name of the signal to be sent immediately to all the worker processes.  If the value is an arrayref the first value is treated the name of the signal and the second value is treated as the interval (in seconds) between sending the signal to each worker process.

### on\_child\_reap

coderef that is called when a child is reaped. Receives the instance to
the current Parallel::Prefork, the child's pid, and its exit status.

### before\_fork

### after\_fork

coderefs that are called in the manager process before and after fork, if being set

## start

The main routine.  There are two ways to use the function.

If given a subref as an argument, forks child processes and executes that subref within the child processes.  The processes will exit with 0 status when the subref returns.

The other way is to not give any arguments to the function.  The function returns undef in child processes.  Caller should execute the application logic and then call `finish` to terminate the process.

The `start` function returns true within manager process upon receiving a signal specified in the `trap_signals` hashref.

## finish

Child processes (when executed by a zero-argument call to `start`) should call this function for termination.  Takes exit code as an optional argument.  Only usable from child processes.

## signal\_all\_children

Sends signal to all worker processes.  Only usable from manager process.

## wait\_all\_children()

## wait\_all\_children($timeout)

Waits until all worker processes exit or timeout (given as an optional argument in seconds) exceeds.
The method returns the number of the worker processes still running.

# AUTHOR

Kazuho Oku

# LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html
