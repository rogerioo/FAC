#include <stdio.h>
#include <math.h>

int main (){
	double serie=0, previous, upper, lower;
	int number, k=0;

	scanf("%d", &number);

	
	do {
		previous = serie;
		upper = pow(-1, k) * pow(number, (-1-2*k));
		lower = (1+2*k);
		serie += (upper/lower);
		k++;
	} while ( (serie - previous) > 0.000000000001 );


	printf("%lf\n", serie);
	return 0;
}
