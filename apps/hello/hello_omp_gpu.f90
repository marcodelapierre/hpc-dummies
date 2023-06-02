program hello90

    integer:: thid, nth, teid, nte, ndev
    integer:: omp_get_thread_num, omp_get_num_threads
    integer:: omp_get_team_num, omp_get_num_teams
    integer:: omp_get_num_devices
    logical:: omp_is_initial_device

    ndev = omp_get_num_devices()
    write (*,*) "Number of available devices ", ndev

    !$omp target 
    !$omp teams num_teams(4) thread_limit(5)
    !$omp parallel

    if ( omp_is_initial_device() ) then
        write (*,*) "Running on host"
    else
        thid = omp_get_thread_num();
        nth= omp_get_num_threads();
        teid = omp_get_team_num();
        nte= omp_get_num_teams(); 
        write (*,*) "Hello from GPU thread ", thid, " (out of ", nth, ") in team ", nte, "(out of ", nte, ")"
    endif

    !$omp end parallel
    !$omp end teams
    !$omp end target

end program
