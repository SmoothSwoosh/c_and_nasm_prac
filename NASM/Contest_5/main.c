#include <stdio.h>

#include <stdlib.h>

#include <math.h>

#include <string.h>

#include <stdbool.h>



const double eps1 = 0.00000001, eps2 = 0.001;



extern double f1(double);

extern double f2(double);

extern double f3(double);



//chord method

double root (double (*f)(double), double (*g)(double), double a, double b, double eps, int *count_iter) {

    double c = 0;

    while (fabs(f(b) - g(b) - f(a) + g(a)) > eps) {

        ++*count_iter;

        c = ((f(b) - g(b)) * a - (f(a) - g(a)) * b) / (f(b) - g(b) - f(a) + g(a));

        if (fabs(b - c) <= eps) break;

        if ((f(a) - g(a)) * (f(c) - g(c)) > 0) a = c;

        else b = c;

    }

    return c;

}



//trapezium method

double integral (double (*f)(double), double a, double b, double eps) {

    double h = eps, n = (b - a) / h, Integral = h * (f(a) + f(b)) / 2.0;

    for (int i = 1; i <= n - 1; ++i)

        Integral = Integral + h * f(a + h * i);

    return Integral;

}



//help

void display_help () {
    printf("--------------------------------------------------------------------------------------------\n");

    printf("command --help: print all keys of cmd\n");

    printf("--------------------------------------------------------------------------------------------\n");

    printf("command --count_iterations: print count of iterations in chord method for all functions\n");

    printf("--------------------------------------------------------------------------------------------\n");

    printf("command --abscissas: print intersections' abscissas in chord method for all functions\n");

    printf("--------------------------------------------------------------------------------------------\n");

    printf("command --test-root: test function root. This command requires two numbers of functions from 1 to 3 (int)\n");

    printf("and the bounders of segment from 1 to +inf (double)\n");

    printf("--------------------------------------------------------------------------------------------\n");

    printf("command --test-root: test function integral. This command requires number of function from 1 to 3 (int)\n");

    printf("and the bounders of segment from -inf to +inf (double)\n");

    printf("\n");

}



int main(int argc, char **argv) {

    double (*vector_of_func[3])(double) = {f1, f2, f3};

    bool flag_inter = false, flag_iter = false;

    int count_iter1 = 0, count_iter2 = 0, count_iter3 = 0; //counter of iterations in root

    for (int i = 1; i < argc; ++i) {

        if (!strcmp(argv[i], "--help")) {

            display_help();

        }

        if (!strcmp(argv[i], "--count_iterations")) {

            flag_iter = true;

        }

        if (!strcmp(argv[i], "--abscissas")) {

            flag_inter = true;

        }

        if (!strcmp(argv[i], "--test-root")) {

            int num1, num2;

            double a, b, ans;

            printf("Root's test is processing...\n");

            printf("Give me the numbers of functions: \n");

            scanf("%d%d", &num1, &num2);

            printf("Give me the bounders of segment: \n");

            scanf("%lf%lf", &a, &b);

            ans = root(vector_of_func[num1 - 1], vector_of_func[num2 - 1], a, b, eps1, &num1);

            printf("Intersection's abscissa is: %.8lf \n", ans);

            printf("\n");

        }

        if (!strcmp(argv[i], "--test-integral")) {

            int num;

            double a, b, ans;

            printf("Integral's test is processing...\n");

            printf("Give me a number of function: \n");

            scanf("%d", &num);

            printf("Give me the bounders of segment: \n");

            scanf("%lf%lf", &a, &b);

            ans = integral(vector_of_func[num - 1], a, b, eps2);

            printf("The value of integral is: %.8lf \n", ans);

            printf("\n");

        }

    }

    double r12 = root(f1, f2, 1, 7, eps1, &count_iter1);

    double r23 = root(f2, f3, 1, 7, eps1, &count_iter2);

    double r13 = root(f1, f3, 1, 7, eps1, &count_iter3);

    if (flag_inter) {

        printf("Intersection's abscissa for f1 and f2: %.8lf\n", r12);

        printf("Intersection's abscissa for f2 and f3: %.8lf\n", r23);

        printf("Intersection's abscissa for f1 and f3: %.8lf\n", r13);

        printf("\n");

    }

    if (flag_iter) {

        printf("Number of iterations for f1 and f2: %d\n", count_iter1);

        printf("Number of iterations for f2 and f3: %d\n", count_iter2);

        printf("Number of iterations for f1 and f3: %d\n", count_iter3);

        printf("\n");

    }

    double integral1 = integral(f1, r13, r12, eps2);

    double integral2 = integral(f2, r23, r12, eps2);

    double integral3 = integral(f3, r13, r23, eps2);

    printf("Square of figure is: %.8lf\n", integral1 - integral2 - integral3);



    return 0;

}
