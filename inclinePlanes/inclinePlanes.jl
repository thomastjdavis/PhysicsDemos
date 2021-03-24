#physics sims starting with incline planes

using Plots

struct Plane
	muS::Float64
	muK::Float64
	theta::Float64
end



function makeDefault(p::Plane)
	plt = plot(xlims=[0,100],ylims=[0,100],legend=false)
	plot!([100-100/(tand(p.theta)),100],[100,0])
	plt
end

function makeDefault(ps::Array{Plane,1})
	plt = plot(xlims=[0,100],ylims=[0,100],legend=false)
	for p in ps
		plot!([100-100/(tand(p.theta)),100],[100,0])
	end
	plt
end

function addBox(x0,p::Plane,title::String)
	plt=makeDefault(p)
	box = [((100-x0)*cosd(p.theta),x0*sind(p.theta)),((100-(x0+10))*cosd(p.theta),(x0+10)*sind(p.theta))]
	plot!(box,w=10,title="μK=$(p.muK), μS=$(p.muS), θ=$(p.theta) $(title)")
	plt
end

#boxes at the same distance x0 from the end
function addBox(x0::Array{Float64},ps::Array{Plane,1},title::String)
	plt=makeDefault(ps)
	i=1
	for p in ps
		box = [(100-x0[i]*cosd(p.theta),x0[i]*sind(p.theta)),(100-(x0[i]+10)*cosd(p.theta),(x0[i]+10)*sind(p.theta))]
		plot!(box,w=10)
		i+=1;
	end
	title!(title)
	plt
end

function travelPlane(x0,ps::Array{Plane,1})
	plt = makeDefault(ps)
	thetas = sort!([p.theta for p in ps];rev=true)
	t_end = sqrt(3*abs(x0)*sind(thetas[1])/9.8)
	vals = range(0.0,t_end,length = 100)
	anim = @animate for t in vals
		for p in ps
			y=x0-4.9*sin(p.theta)*t^2
			box = [(100-y*cosd(p.theta),y*sind(p.theta)),(100-(y+10)*cosd(p.theta),(y+10)*sind(p.theta))]
			plot!(box,w=10)
		end
		
	end
	gif(anim,"boxOnPlanes.gif",fps=25)
end
function travelPlane1(x0,ps::Array{Plane,1})
	plt = makeDefault(ps)
	thetas = sort!([p.theta for p in ps];rev=true)
	t_end = sqrt(2*abs(x0)*sind(thetas[1])/9.8)
	vals = range(0.0,t_end,length = 100)
	anim = @animate for t in vals
		addBox([x0-(4.9*t^2)*sind(p.theta) for p in ps],ps,"t=$t seconds")	
	end
	gif(anim,"boxOnPlanes.gif",fps=25)
end

function travelPlane(x0,p::Plane)
	
	
	t_end = sqrt(3*abs(x0)*sind(p.theta)/9.8)
	
	vals = range(0.0,t_end,length = 100)
	anim = @animate for t in vals
		addBox(x0-4.9*sin(p.theta)*t^2,p,"t=$(t) seconds")
	end
	gif(anim,"boxPlane.gif",fps=25)
end


