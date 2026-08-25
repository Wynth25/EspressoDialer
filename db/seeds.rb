puts "Wiping existing data to start fresh..."
Brew.destroy_all
Recipe.destroy_all
Basket.destroy_all
Bean.destroy_all

puts "Generating Baskets..."
baskets = [
  Basket.create!(name: "Bottomless Ikape", min_dose: 16.0, max_dose: 19.0),
  Basket.create!(name: "VST 18g Ridgeless", min_dose: 17.0, max_dose: 19.0),
  Basket.create!(name: "IMS Precision 18-22g", min_dose: 18.0, max_dose: 22.0),
  Basket.create!(name: "Decent Espresso 15g", min_dose: 14.0, max_dose: 16.0),
  Basket.create!(name: "Rocket Standard Double", min_dose: 14.0, max_dose: 18.0)
]

puts "Generating Beans..."
beans_data = [
  { roastery: "Doubleshot", name: "Era", description: "Bolivia - Palli Family, Caturra, Washed", notes: "stone fruit, almonds and molasses", roast_date: "2026-08-14", frozen_on: "2026-08-18" },
  { roastery: "Father's Artisan Roasters", name: "Los Pirineos", description: "El Salvador, Pacamara, Honey", notes: "Orange, honey, floral", roast_date: "2026-08-14", frozen_on: "2026-08-18" },
  { roastery: "The Miners", name: "Fazenda Pinhal", description: "Brazil, Mundo Novo, Natural", notes: "Milk chocolate, hazelnut, nougat", roast_date: "2026-08-01", frozen_on: nil },
  { roastery: "Candycane Coffee", name: "El Paraiso", description: "Colombia, Castillo, Anaerobic", notes: "Strawberry, lychee, bubblegum", roast_date: "2026-08-10", frozen_on: nil },
  { roastery: "Rusty Nails Coffee", name: "Karogoto", description: "Kenya, SL28/SL34, Washed", notes: "Blackcurrant, tomato, juicy", roast_date: "2026-07-25", frozen_on: "2026-08-05" },
  { roastery: "Nordbeans", name: "Antigua", description: "Guatemala, Bourbon, Washed", notes: "Caramel, green apple, cocoa", roast_date: "2026-08-12", frozen_on: nil },
  { roastery: "Naughty Dog", name: "Tarrazu", description: "Costa Rica, Caturra, Natural", notes: "Plum, dark chocolate, cinnamon", roast_date: "2026-08-08", frozen_on: nil },
  { roastery: "Fiftybeans", name: "Gitega Hills", description: "Rwanda, Red Bourbon, Washed", notes: "Black tea, lemon, floral", roast_date: "2026-08-15", frozen_on: nil },
  { roastery: "La Cabra", name: "Los Cedros", description: "Honduras, Lempira, Washed", notes: "Vanilla, red apple, milk chocolate", roast_date: "2026-07-20", frozen_on: "2026-08-02" },
  { roastery: "Gardelli", name: "Mzungu Project", description: "Uganda, SL14, Natural", notes: "Pineapple, strawberry, cacao", roast_date: "2026-08-05", frozen_on: nil }
]

beans = beans_data.map.with_index do |data, index|
  Bean.create!(
    roastery: data[:roastery],
    name: data[:name],
    description: data[:description],
    notes: data[:notes],
    roast_date: Date.parse(data[:roast_date]),
    frozen_on: data[:frozen_on] ? Date.parse(data[:frozen_on]) : nil,
    archived: false,
    position: index + 1
  )
end

puts "Generating random, realistic Recipes and Brew History..."
styles = ["Ristretto", "Espresso", "Lungo"]
ratios = ["1:1.5", "1:2", "1:2.5", "1:3"]

beans.each do |bean|
  # 1 to 3 different basket/style combinations per bean
  rand(1..3).times do
    basket = baskets.sample
    style = styles.sample
    
    # 1. Create the Recipe (No measurements here!)
    recipe = Recipe.create!(
      bean: bean,
      basket: basket,
      style: style,
      archived: false
    )

    # Pick a starting dose that fits inside this specific basket's limits
    current_dose = rand(basket.min_dose..basket.max_dose).round(1)
    # Pick a random starting grind size (e.g., between 10.0 and 15.0)
    current_grind = rand(10.0..15.0).round(1)

    # 2. Simulate 2 to 5 dial-in attempts (brews) for this recipe
    rand(2..5).times do |i|
      # Adjust dose slightly (-0.5g to +0.5g), but force it to stay within basket limits
      dose_shift = rand(-0.5..0.5)
      current_dose = (current_dose + dose_shift).clamp(basket.min_dose, basket.max_dose).round(1)
      
      # Adjust grind randomly (-0.4 to +0.4)
      grind_shift = rand(-0.4..0.4)
      current_grind = (current_grind + grind_shift).round(1)
      
      # Generate realistic ratings for this step
      ratings = ["Too fast", "Choked", "Sour", "Bitter", "Balanced", "Perfect"]

      # 3. Save the actual measurements to the Brew table
      Brew.create!(
        recipe: recipe,
        dose: current_dose,
        grind: current_grind,
        rating: ratings.sample
      )
    end
  end
end

puts "Database seeded successfully with dynamic dial-in data!"