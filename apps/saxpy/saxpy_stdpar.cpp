#include <iostream>
#include <cmath>
#include <ctime>
#include "my_timer.h"
#include <algorithm>
#include <execution>

using namespace std;


// Verify SAXPY result
float verify_saxpy( const float tot, std::vector<float> const &y )
{
  float err = 0.;
  for (size_t i = 0; i < y.size(); i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}

// Perform SAXPY
void saxpy( const float a, 
            std::vector<float> const &x, std::vector<float> &y )
{
  std::transform(std::execution::par,
                 x.begin(), x.end(), y.begin(), 
                 y.begin(),
                 [=](double x, double y) { return a * x + y; });
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
std::vector<float> x(N);
std::vector<float> y(N);
// More definitions
float clocktime, err;

// Fill values
std::fill_n(std::execution::par, x.begin(), x.size(), XVAL);
std::fill_n(std::execution::par, y.begin(), y.size(), YVAL);

// Start timer
//clock_t start = clock();
my_timer timer;
// SAXPY
saxpy( AVAL, x, y );
// Stop timer
//clock_t watch = clock() - start;
//const float clocktime = ((float)watch)/CLOCKS_PER_SEC;
clocktime = (float)timer.elapsed();

// SAXPY verification
err = verify_saxpy( tot, y );

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

return 0;
}