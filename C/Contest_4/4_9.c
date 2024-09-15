#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
const size_t MAXSIZE = 1024 * 1024;

int main(void) {
    FILE *f_in = fopen("input.bin", "rb");
    FILE *f_out = fopen("output.bin", "wb");
    int *arr = (int *) calloc (MAXSIZE, sizeof(int));
    size_t len = 0;
    while (fread(&arr[len], 4, 1, f_in) == 1) {
        ++len;
    }
    int ans = -2;
    for (size_t i = 0; 2 * i + 1 < len; ++i) {
        if (arr[i] < arr[2 * i + 1]) {
            if (ans == -1) { ans = 0; break; }
            if (2 * i + 2 < len) {
                if (arr[2 * i + 2] >= arr[i]) {
                    ans = 1;
                }
                else {
                    ans = 0;
                    break;
                }
            } else {
                ans = 1;
            }
        } else if (arr[i] > (arr[2 * i + 1])) {
            if (ans == 1) { ans = 0; break; }
            if (2 * i + 2 < len) {
                if (arr[2 * i + 2] <= arr[i]) {
                    ans = -1;
                }
                else {
                    ans = 0;
                    break;
                }
            } else {
                ans = -1;
            }
        } else {
            bool flag = false;
            if (ans == 1 || ans == -2) {
                if (arr[i] <= arr[2 * i + 1]) {
                    if (2 * i + 2 < len) {
                        if (arr[2 * i + 2] >= arr[i]) {
                            ans = 1;
                            flag = true;
                        }
                    } else {
                        ans = 1;
                        flag = true;
                    }
                }
            }
            if ((!flag && ans == -1) || ans == -2) {
                if (arr[i] >= (arr[2 * i + 1])) {
                    if (2 * i + 2 < len) {
                        if (arr[2 * i + 2] <= arr[i]) {
                            ans = -1;
                            flag = true;
                        }
                    } else {
                        ans = -1;
                        flag = true;
                    }
                }
            }
            if (!flag) {
                ans = 0;
                break;
            }
        }
    }
    if (len == 1) {
        ans = 1;
    }
    fwrite(&ans, 4, 1, f_out);
    free(arr);
    fclose(f_in);
    fclose(f_out);
    return 0;
}