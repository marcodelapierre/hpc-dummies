#include <chrono>

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

