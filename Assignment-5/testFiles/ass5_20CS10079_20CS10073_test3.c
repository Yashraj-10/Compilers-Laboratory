int main()
{
	int i = 0, j, n = 12;
	j = 100;
	int arr[5]; // 1D integer array	

	int sum = 0;
	// testing while lopp
	while(i<n) 
	{
		i++;
		sum += arr[i];
	}

	sum = 0;
	int mat[5][5]; // 2D integer array
	// nested for loop
	for(i = 0;i<n;i++)
	{
		for(j = 0;j<n;j++)  
			mat[i][j] = sum/(i*j); 
	}
	return 0;

	// testing do-while loop
	do 
	{
		--j;
		++i;
		arr[i] = (i-j);
	}while(i<16);
}

//  1D arrays, 2D array, add-assign (shorthand assignment), loops (while, for, do-while) and nested loops