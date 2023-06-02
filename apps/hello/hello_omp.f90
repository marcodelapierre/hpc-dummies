program hello90

    integer:: id, nthreads
    integer:: omp_get_thread_num, omp_get_num_threads

    !$omp parallel private(id,nthreads)

    id = omp_get_thread_num()
    nthreads = omp_get_num_threads()

    write (*,*) "Hello World from thread = ", id

    if (id == 0) then
        write (*,*) "Number of threads = ", nthreads
    endif

    !$omp end parallel

end program
