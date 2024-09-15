#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  char *s;
  s = (char *)malloc((1e6 + 1) * sizeof(char));
  scanf("%s", s);

  int cnt_even = 0, cnt_odd = 0;
  for (int i = 1; i <= strlen(s); i++) {
    if (s[i - 1] == 'A') {
      if (i % 2 == 0) 
        cnt_even++;
      else
        cnt_odd++;
    }
  }

  int cnt_tmp_even = 0, cnt_tmp_odd = 0;
  int cnt_most_tmp_even = 0, cnt_most_tmp_odd = 0;

  for (int i = 1; i <= strlen(s); i++) {
    if (s[i - 1] == 'B') {
      cnt_most_tmp_even = cnt_tmp_even + (cnt_odd - cnt_tmp_odd);
      cnt_most_tmp_odd = cnt_tmp_odd + (cnt_even - cnt_tmp_even);
    } else {
      if (i % 2 == 0) {
        cnt_most_tmp_even = cnt_tmp_even + (cnt_odd - cnt_tmp_odd);
        cnt_most_tmp_odd = cnt_tmp_odd + (cnt_even - cnt_tmp_even - 1);
        cnt_tmp_even++;
      } else {
        cnt_most_tmp_even = cnt_tmp_even + (cnt_odd - cnt_tmp_odd - 1);
        cnt_most_tmp_odd = cnt_tmp_odd + (cnt_even - cnt_tmp_even);
        cnt_tmp_odd++;
      }
    }
    if (cnt_most_tmp_even == cnt_most_tmp_odd)
      printf("%d ", i);  
  }

  free(s);

  return 0;
}