def expectedAttributePlot(db, table, attribute, M, color=[]):	
	
	#SIZE = (float(100)/float(len(M) ) ) * 15
	SIZE = 1
	conn = sqlite3.connect(db)
	c = conn.cursor()
	
	P = []
	p_ind = -1
	
	for m in M:	
		P.append([])
		p_ind += 1
		x = -1
		for i in c.execute('select a, b from ' + table + ' where M = ' + str(m) ):
			
			if ( (x < float(i[0])/ float(i[1])  ) or (x == -1) ): #and not float(i[0])/ float(i[1])
				x = float(i[0])/ float(i[1])
				P[p_ind].append([ int(i[0]), int(i[1]) ])
				
			elif x > float(i[0])/ float(i[1]):
				break
				
	
	Y_vals = []
	for l in range(0, len(M)):
		Y_vals.append([])
		for p in range(0, len(P[l]) ):
			Y_vals[l].append([])
			#print('select ' + attribute + ' from ' + table + ' where M = ' + str(M[l]) + ' and a = ' + str(P[l][p][0]) + ' and b = ' + str(P[l][p][1]) )
			for i in c.execute('select ' + attribute + ' from ' + table + ' where M = ' + str(M[l]) + ' and a = ' + str(P[l][p][0]) + ' and b = ' + str(P[l][p][1]) ):
				Y_vals[l][p].append( float(i[0]) )
				
	conn.close()
			
	G = []
	for m in range(0, len(Y_vals) ):
		G.append([])
		for y in range(0, len(Y_vals[m]) ):
			#G[m].append( [float( P[m][y][0] ) / float( P[m][y][1] ) , float(sum(Y_vals[m][y] ) ) / float(len(Y_vals[m][y]) ) ])
			G[m].append( [float( P[0][y][0] ) / float( P[0][y][1] ) , float(sum(Y_vals[m][y] ) ) / float(len(Y_vals[m][y]) ) ])
			
	L = []

	#print(G)

	
	for g in range(0, len(G)):
		if len(color) > 0:	
			L.append( list_plot(G[g], color=color[g], title='Expected ' + attribute, axes_labels=['$p$', 'Avg ' + attribute], legend_label='$M = $' + str(M[g]) ) )
		else:		
			L.append( list_plot(G[g], rgbcolor=hue(1/2 + (g+1)/(2*len(M))), title='Expected ' + attribute, axes_labels=['$p$', 'Avg ' + attribute], legend_label='$M = $' + str(M[g]) ) )
		
	return sum(L)