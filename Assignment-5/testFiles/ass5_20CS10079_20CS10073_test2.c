// ternary operators, if-else conditions, function calls (simple and nested)
int randm_func(int x, int y, int d) 
{
	int ans = d;
	if(x>y)  // if-else
		ans += x;
	else
	{
   		ans *= y;
	}
	return ans;
}

int min(int x, int y) 
{
   int min_val;
   // ternary operator
   min_val = x>y ? y : x; 
   return min_val;
}

// a random function to test nested function calls
int randm_nested(int x, int y)
{
	int ans = 1;
	if(x < 3) 
	{
		ans = randm_func(x, y, 5);
	}
	return ans;
}

int main() 
{
	int diff, x, y;
	int b = 5;
	diff = randm_nested(10, b);
	x = 2;
	y = 3;
	b = randm_func(min(x, 3), min(5, y), 2);
	return 0;
}