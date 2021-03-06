GenerateNumericalSemigroup := function(m, a, b)
	#Generates a random numerical semigroup by choosing integers 2 through m with probability a/b.
	
	local S, s, i;
	
	if (not IsInt(m) or not IsInt(a) or not IsInt(b) or a > b or m < 2) then
		Error("GenerateNumericalSemigroup(m, a, b): m, a, and b must be nonnegative integers with a <= b and m > 1.\nm := Maximum possible generator\na/b := Probability of choosing a generator");
	fi;
	
	S := [];
	
	for i in [2..m] do
		if Random([1..b]) <= a then
			Add(S,i);
		fi;
	od;
	
	
	if not IsEmpty(S) and Gcd(S) = 1 then
		s := NumericalSemigroup(S);
	else
		s := [];
	fi;
	
	return(s);
end;





GenerateNumericalSemigroupAp := function(m, a, b)
	#Generate random numerical semigroup with by choosing integers from 2 through m with probability a/b.
	#Generated by calculating Apery set as generators are chosen.

	local A, A1, S, g, s, n, t, t_p, p, i, q, size, val, index, g1, l_index, r_index, num;

	if (not IsInt(m) or not IsInt(a) or not IsInt(b) or a > b or m < 2) then
		Error("GenerateNumericalSemigroupAp(m, a, b): m, a, and b must be nonnegative integers with a <= b and m > 1.\nm := Maximum possible generator\na/b := Probability of choosing a generator");
	fi;

	S := [];
	A := [];
	p := [];
	g := 1;
	n := 0;
	num := 0;
	size := 1;
	
	for i in [2..m] do
		if Random([1..b]) <= a then
			n := i;
			#Print("Gen number 1: ", n, "\n");
			Add(S, n);
			size := 1;
			break;
		fi;
	od;
	
	
	for i in [1..n] do
		Add(A, 0);
	od;
	
	if not Size(S) = 0 then
		for i in [1..n-1] do
			Add(p, [i, 1, i-1, i+1]);
		od;

		p[1][3] := n - 1;
		p[n-1][4] := 1;
	fi;
	

	t := 1;
	
	index := 1;

	while size < n and size > 0 do
		#Print("t = ", (n * p[index][2]) + p[index][1], "  n = ", n, "  p[index] = ", p[index], "\n");
		
		if n * p[index][2] + p[index][1] > m and (Size(S) = 0 or size = S[1]/Gcd(S)) then
			#Print("Breaking, t = ", n * p[index][1] + p[index][2], " p: ", p, "\n");
			break;
		fi;
		
		val := false;
		#Print("A: ", A, "\n");
		for s in S do
			t_p := (n * p[index][2]) + p[index][1] - s;
		
			for q in A do
				if t_p = q then    val := true;  break;  fi;
			od;
		
			if val then break; fi;
		od;
		
		#Print("t = ", (n * p[index][2]) + p[index][1], "   val = ", val, "\n");
	
		if val then 
			#Print("val = true, ", t_p, " = ", q, "\n");
			A[index + 1] := n * p[index][2] + p[index][1];
			size := size + 1;
		
			l_index := p[index][3];
			r_index := p[index][4];
		
			p[l_index][4] := r_index;
			p[r_index][3] := l_index;
		
			#Print("P: ", p, "\nA: ", A, "\n");
		else
			num := n * p[index][2] + p[index][1];
			#Print("Num: ", num, "\n");
			
			if num <= m and A[index + 1] = 0 then
				#Print("RANDOM: ", Random([1..b]), "   a: ", a, "  b: ", b, "\n" );
				
				
				if Random([1..b]) <= a then
				
				#M_index := M_index + 1;
				#Print("M_index ", M_index, "\n");
				#if M[M_index] <= a then
					#Print("Picked: ", M[M_index], "\n");
					Add(S, num);
					A[index + 1] := n * p[index][2] + p[index][1];
				
					l_index := p[index][3];
					r_index := p[index][4];
				
					p[l_index][4] := r_index;
					p[r_index][3] := l_index;
				
					size := size + 1;
				fi;
			fi;
		
			p[index][2] := p[index][2] + 1; 
		fi;
	
		index := p[index][4];
		g := g + 1;
	od;


	if Size(S) > 0 then g := Gcd(S); fi;

	if not g = 1 then
		A1 := [];
		Add(A1, 0);

		for i in A do
			if not i = 0 then
				Add(A1, i/g);
			fi;
		od;

	fi;


	if Size(S) = 1 then
		return [NumericalSemigroup([1]), S, n, g];
	else if Size(S) = 0 then
		return [[], S, n, g];
	fi;
	fi;
	
	

	if g = 1 and n >0 then
		#return [A, S];
		#Print("A: ", A, "\n");
		#Print("FrobNum: ", FrobeniusNumber(NumericalSemigroupByAperyList(A)), "  NumGaps: ", GenusOfNumericalSemigroup(NumericalSemigroupByAperyList(A)), "\n" );
		#return [NumericalSemigroupByAperyList(A), S, n, g];
		return NumericalSemigroupByAperyList(A);
	else
		return [];
	#else if n >0 then
		#return [A1, S];
		#Print("A1: ", A1, "\n");
		#return [NumericalSemigroupByAperyList(A1), S, n, g];
	#fi;
	fi;
	#return([A, S, p]);


end;



RunExperimentM := function(len, filename, tablename, attributes, M, a, b, create, GenSG)
	local X, x, g, n, l, i, j, att, temp, all_int;

	all_int := true;

	for m in M do
		if not IsInt(m) then
			all_int := false;
			break;
		fi;
	od;

	if not IsList(M) or not (all_int) then
		Error("Invalid fifth argument, should be a list of integer upper bounds M");
	fi;

	for i in [1..Length(M)] do
		if i = 1 and create = 1 then
			RunExperiment(len, filename, tablename, attributes, M[i], a, b, 1, GenSG);
		
		else
			RunExperiment(len, filename, tablename, attributes, M[i], a, b, 0, GenSG);
		fi;
	od;

end;



RunExperiment := function(len, filename, tablename, attributes, M, a, b, create, GenSG)
	local X, x, g, n, l, i, j, att, temp;

	#attributes nested array, each element is an array of length 3 including attribute name, function name, and type for SQL
	#do error for types and lengths in attributes and make sure no repeats
	#GenSG the chosen function to randomly generate a semigroup with parameters M, a, and b
	#ensure that the outputs of verified functions are a semigroup
	if not IsInt(len) then
		Error("Invalid first argument, should be an integer for number of iterations");
	fi;

	if not IsString(filename) then
		Error("Invalid second argument, should be string of filename");
	fi;

	if not IsString(tablename) then
		Error("Invalid third argument, should be string of tablename for SQL");
	fi;

	if not IsList(attributes) then
		Error("Invalid fourth argument, should be list, each element a list containing string attribute name, function, and string SQL type");
	fi;

	for j in attributes do
		if not IsList(j) or not(Length(j) = 3) or not IsString(j[1]) or not IsString(j[3]) or not IsFunction(j[2]) then
			Error("Invalid fourth argument, should be list, each element a list containing string attribute name, function, and string SQL type");
		fi;
	od;

	if not IsInt(M) or M < 2 then
		Error("Invalid fifth argument, should be integer for upper bound for generators");
	fi;

	if not IsInt(a) or a < 1 or not IsInt(b) or b < 1 then
		Error("Invalid sixth and/or seventh arguments, should be integers for probability, p, of picking generators where p = a/b");
	fi;

	if not IsInt(create) or not (create = 0 or create = 1) then
		create := 1;
	fi;

	if GenSG = "" then
		GenSG := GenerateNumericalSemigroupAp;
	fi;


	if create = 1 then
		AppendTo(filename, "create table ", tablename, "(id integer primary key autoincrement, M integer, ");
		AppendTo(filename, "a integer, b integer");
		for att in attributes do
			AppendTo(filename, ", ", att[1], " ", att[3]);
		od;
		
		AppendTo(filename, ");\n");
	fi;

	#FIXME probably don't append data that don't represent semigroups, change for to while
	i := 1;
	while i <= len do
		X := GenSG(M, a, b);

		#g := Gcd(X); #FIXME decide what to do about gcd and repeating semigroups
		#return different type for generating functions if generators not coprime and check the length of X before appending to file FIXME
		
		if IsNumericalSemigroup(X) then
			AppendTo(filename, "insert into ", tablename, "(M, a, b");
			for att in attributes do
				AppendTo(filename, ", ", att[1]);
			od;


			AppendTo(filename, ") values (", M, ", ", a, ", ", b);
			for att in attributes do
				temp := att[2](X);
				if att[3] = "text" and (not IsString(temp)) then
					AppendTo(filename, ", \"", temp, "\"");
				else
					AppendTo(filename, ", ", temp);
				fi;
			od;
		
			AppendTo(filename, ");\n");
			i := i + 1;

		fi;
		
	od;

end;




RunExperimentP := function(len, filename, tablename, attributes, M, a1, b1, a2, b2, plen, GenSG)
	local S, in_len_a, in_len_b, n, s;
	
	if ((a1/b1) >= (a2/b2)) then
		Error("a1/b1 < a2/b2\n");
	fi;
	
	S := [];
	in_len_a := a2*b1 - a1*b2;
	in_len_b := b1*b2*plen;
	n := a1/b1;
	
	while  (n < a2/b2) do
		Add(S, n);
		n := n + (in_len_a/in_len_b);
	od;
	
	Add(S,n);
	
	for s in S do
		RunExperiment(len, filename, tablename, attributes, M, NumeratorRat(s), DenominatorRat(s), 1, GenSG);
		#Print(s, "\n");
	od;
	
end;



RunExperimentPM := function(len, filename, tablename, attributes, M, a1, b1, a2, b2, plen, GenSG)
	local X, x, g, n, l, i, j, att, temp, all_int;

	if not IsList(M) then
		Error("Invalid fifth argument, should be a list of integer upper bounds M");
	fi;

	for m in M do
		if not isInt(m) then
			Error("Invalid fifth argument, should be a list of integer upper bounds M");
		fi;
	od;

	

	for m in M do
		RunExperimentP(len, filename, tablename, attributes, m, a1, b1, a2, b2, plen, GenSG);
	od;

end;

NumMinGens := function(g)

	if not IsNumericalSemigroup(g) then
		Error("Invalid argument, shuold be a Numerical Semigroup");
	fi;

	return Length(MinimalGeneratingSystemOfNumericalSemigroup(g));
end;