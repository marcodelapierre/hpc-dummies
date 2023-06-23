#include <cstdio>
#include <algorithm>
#include <ranges>
#include <execution>


int main(int argc, char* argv[]) {

  int n_repeats = 15;
  auto ints = std::views::iota(0, n_repeats);

  std::for_each_n(std::execution::par, 
    ints.begin(), ints.size(), 
    [](int i) { printf("Hello from i = %i\n", i); });

}