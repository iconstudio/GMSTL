// objPlayer_find_begin(0beginline, 1begindelta, 2targetline, 3targetdelta)
var i, j, l, ld, lcnt, result, minlen, minind;

if (argument0 = argument2)
	return argument2;

tdep = 0;
tval[0] = argument0;
lcnt = 0;

for (i = 0; i < lines; i += 1) {
	if (i != argument0) {
		if (linea[i] = linea[argument0] || lineb[i] = linea[argument0]) {
			l[lcnt] = i;
			ld[lcnt] = lined[argument0] * argument1;
			lcnt += 1;  
		} else if (linea[i] = lineb[argument0] || lineb[i] = lineb[argument0]) {
			l[lcnt] = i;
			ld[lcnt] = lined[argument0] * (1 - argument1);
			lcnt += 1;
		}
	}
}

if (lcnt = 0) {
	return -1;
} else {
	minind = -1;
	minlen = -1;

	for (i = 0; i < lcnt; i += 1) {
		if (l[i] = argument2)
			return argument2;

		result = objPlayer_find_depth(l[i], argument2, argument3, ld[i] + lined[l[i]], 1);

		if (result >= 0 && (minind = -1 || result < minlen)) {
			minind = l[i];
			minlen = result;
		}
	}

	return minind;
}

// objPlayer_find_depth(0beginline, 1targetline, 2targetdelta, 3length, 4depth)
var i, j, l, ld, lcnt, result, minimum;

tdep = argument4;
tval[tdep] = argument0;
lcnt = 0;

for (i = 0; i < lines; i += 1) {
	for (j = 0; j <= tdep; j += 1) {
		if (tval[j] = i)
			break;
		if (linea[i] = linea[tval[tdep - 1]] || linea[i] = lineb[tval[tdep - 1]] || lineb[i] = linea[tval[tdep - 1]] || lineb[i] = lineb[tval[tdep - 1]])
			break;
	}

	if (j = tdep + 1) {
		if (linea[i] = linea[argument0] || lineb[i] = linea[argument0] || linea[i] = lineb[argument0] || lineb[i] = lineb[argument0]) {
			l[lcnt] = i;
			ld[lcnt] = lined[argument0];
			lcnt += 1;
		}
	}
}

if (lcnt = 0) {
	return -1;
} else {
	minind = -1;
	minlen = -1;

	for (i = 0; i < lcnt; i += 1) {
		if (l[i] = argument1) {
			if (linea[l[i]] = linea[argument0] || linea[l[i]] = lineb[argument0])
				return argument3 + ld[i] * argument2;
			else
				return argument3 + ld[i] * (1 - argument2);
		}
		
		result = objPlayer_find_depth(l[i], argument1, argument2, argument3 + ld[i], argument4 + 1);
		if (result >= 0 && (minind = -1 || result < minlen)) {
			minind = l[i];
			minlen = result;
		}
		
	}
	
	return minlen;
}

// Create
delay = 0;
push = 0;
mouseover = 0;

points = 2;
pointx[0] = 362;
pointy[0] = 320;
pointx[1] = 662;
pointy[1] = 320;


lines = 1;
linea[0] = 0;
lineb[0] = 1;

for (i = 0; i < lines; i += 1) {
	lined[i] = point_distance(pointx[linea[i]], pointy[linea[i]], pointx[lineb[i]], pointy[lineb[i]]);
	linen[i] = 0;
	linep[i] = 0;
	linex[i] = (pointx[linea[i]] + pointx[lineb[i]]) / 2;
	liney[i] = (pointy[linea[i]] + pointy[lineb[i]]) / 2;
	liner[i] = point_direction(pointx[linea[i]], pointy[linea[i]], pointx[lineb[i]], pointy[lineb[i]]);
}

tline = -1;
tvalue = 0;

movespd = 4;
moveline = 0;
movevalue = 0.5;
event_user(0);

// Step
var i, mx, my, movesize, target, over;

mx = mouse_x;
my = mouse_y;

if (delay > 0)
	delay -= 1;

push -= push / 5;
image_angle = point_direction(x, y, mx, my);

target = objPlayer_find_begin(moveline, movevalue, tline, tvalue);

if (target = -1)
	exit;

movesize = movespd / lined[moveline];
if (moveline != target) {
	if (linea[moveline] = linea[target] || linea[moveline] = lineb[target])
		movevalue -= movesize;
	else
		movevalue += movesize;

	if (movevalue > 1) {
		over = (movevalue - 1) * movespd / lined[target];
		if (linea[target] = lineb[moveline])
			movevalue = over;
		else
			movevalue = 1 - over;
		moveline = target;
	} else if (movevalue < 0) {
		over = -movevalue * movespd / lined[target];
		if (linea[target] = linea[moveline])
			movevalue = over;
		else
			movevalue = 1 - over;
		moveline = target;
	}
} else {
	if (abs(movevalue - tvalue) < movesize) {
		movevalue = tvalue;
	} else {
		movevalue -= sign(movevalue - tvalue) * movesize;
	}
}

event_user(0);

// Mouse Right Click
var mx, my;

mx = mouse_x;
my = mouse_y;

tline = -1;
for (i = 0; i < lines; i += 1) {
	linen[i] = median(0, 1, line_normalize(pointx[linea[i]], pointy[linea[i]], pointx[lineb[i]], pointy[lineb[i]], mx, my));
	linep[i] = point_distance(lerp(pointx[linea[i]], pointx[lineb[i]], linen[i]), lerp(pointy[linea[i]], pointy[lineb[i]], linen[i]), mx, my);

	if (tline = -1)
		tline = i;
	else if (linep[i] < linep[tline])
		tline = i;
	
	if (tline = i) {
		tvalue = linen[i];
	}
}

// User Event 0 
x = (pointx[lineb[moveline]] - pointx[linea[moveline]]) * movevalue + pointx[linea[moveline]];
y = (pointy[lineb[moveline]] - pointy[linea[moveline]]) * movevalue + pointy[linea[moveline]];
