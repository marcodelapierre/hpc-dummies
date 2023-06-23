#include <iostream>
#include <algorithm>
#include <ranges>
#include <execution>


int main(int argc, char* argv[]) {

  int n_repeats = 15;

  auto ints = std::views::iota(0, n_repeats);
  std::for_each_n(ints.begin(), ints.size(), [](int i) { std::cout << "Hello from i = " << i << std::endl ; });

}