class Sentence
	
	def make
		noun = ["Jason 2","Jason","Damien","Shout","The concert","Los Angeles", "Chicago", "This traffic","Your mom"]
		adjective = ["smart","cool","dumb","pusillanimous","hot","unanimous","archaic","smooth","quiet","shivering","splendiferous"]
		object_noun = ["rigamarole","thing","androgynaut","place","horse","spider","grocery store"]


		return "#{noun.sample} is a #{adjective.sample} #{object_noun.sample}."
	end

end