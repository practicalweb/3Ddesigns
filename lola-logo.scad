 
scale([0.1, 0.1, 0.5]) {
linear_extrude(height = 6, center = false, convexity = 10, twist = 0)
import(file="//home/sean/lola-logo.dxf", convexity=3);
translate(v = [-20, -100, 0])
cube(size = [460,200,4], center=false);
}