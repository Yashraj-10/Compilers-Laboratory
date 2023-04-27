// testing pointers (swapping) and typecasting

int division(float a, float b)
{
	int quotient;
	// float converted to int
	quotient = a/b; 
	return quotient;
}

// nested function call
int remainder(int x, int y){
	// returns (x%y)
	int q = quotient(x, y);
	int r = x-y*q;
	return r;
}

void swap(int* a, int* b) // pointers use case 
{
	int temp = *a;
	*a = *b;
	*b = temp;
	return;
}

int main()
{
	int q = 0,r = 0;
	float x = 2.5;
	q = division(x, 1.2);
	r = 10;
	swap(&q, &r);
	r = remainder(12, 5);
	return 0;
}