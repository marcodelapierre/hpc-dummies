#include <iostream>
#include <cmath>
#include <chrono>
#include <ctime>

using namespace std;


// Timer class
// from https://github.com/bennylp/saxpy-benchmark
class my_timer
{
public:
    my_timer() { reset(); }
    void reset() {
      t0_ = std::chrono::high_resolution_clock::now();
    }
    double elapsed(bool reset_timer=false) {
      std::chrono::high_resolution_clock::time_point t =
        std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> time_span =
        std::chrono::duration_cast<std::chrono::duration<double>>(t - t0_);
      if (reset_timer)
        reset();
      return time_span.count();
    }
private:
    std::chrono::high_resolution_clock::time_point t0_;
};

// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0;
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}

// Perform SAXPY
void saxpy( const size_t n, const float a, 
            const float* const x, float* const y )
{
  for ( size_t i = 0; i < n; i++ ) {
    y[i] = a * x[i] + y[i];
  }
}


int main( int argc, char** argv ) {

// Size of problem
const unsigned N = (1 << 26);
// Random values
const float XVAL = rand() % 1000000;
const float YVAL = rand() % 1000000;
const float AVAL = rand() % 1000000;
const float tot = AVAL * XVAL + YVAL;
// Allocate arrays
float* x = new float [ N ];
float* y = new float [ N ];
// Fill values
for ( size_t i = 0; i < N; i++ ) {
  x[i] = XVAL;
  y[i] = YVAL;
}

// Start timer
//clock_t start = clock();
my_timer timer;
// SAXPY
saxpy( N, AVAL, x, y );
// Stop timer
//clock_t watch = clock() - start;
//const float clocktime = ((float)watch)/CLOCKS_PER_SEC;
auto clocktime = timer.elapsed();

// SAXPY verification
const float err = verify_saxpy( tot, N, y);

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

// Deallocate arrays
delete [] y;
delete [] x;

return 0;
}