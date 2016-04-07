defmodule BreadthFirst do
  @moduledoc """
  This is a Graph based Search Algorithm that is very popular in A.I..
  The concept is to find the quickest path to a specific destination.
  This should only be used if there is a possible solution to be found, and if
  the depth of the search doesn't go that deep. Really deep levels of search
  can potentially make this algorithm search run for a very long time simply because
  it checks every single parent node and its children one by one.
  # Examples of real world usages
  - Finding quickest root to a place
  - Finding a specific item that is known to be present in a group of other items
  - Finding a anomaly in a group of related objects
  """

  def search({room, item}) do
    start_unexplored_rooms_list
    if room in unexplored_rooms do
      start_exploring_rooms
      expand(room)
      find_in_room(item)
    else
      IO.puts("I don't understand.")
    end
  end

  defp house do
    %{
        kids_room: ["Crib", "Teddy Bear", "Blanket", "Pacifier", "Tent",
          "Book Bag", "Piggy Bank", "Toy Box", "Cat In the Hat Book",
          "Pirate Ship", "LapTop"],
        laundry_room: ["Basket", "detergent", "Lysol", "Matches",
          "Clothes Line", "Broom", "Dust Pan", "Doggie Bed", "Mop"],
        back_yard: ["Tonka Truck", "Cheerios", "Basketball", "Plants",
          "Hammock", "Pool", "Wet bar", "Wet Suit", "Grill", "Hose",
          "Sun Glasses", "Gnome Statue"],
        game_room: ["Playstation 3", "Xbox", "Wallet","Jumanji Board Game",
          "TV", "pool table"],
        bath_room: ["Hair Spray", "Tooth brush", "soap", "Sleeping Pills",
          "Tooth Paste", "Bath Towels", "Plunger", "Bathroom rug",
          "Shower Curtain"],
        master_bedroom: ["Picture", "Cat", "Pillow", "Armoire", "Night Stand",
          "Plant Container", "Drapes", "Headboard", "Blinds", "Vases", "Photos",
          "Clothing", "Telephone", "Jewlery Boxes", "DVD Player"],
        green_house: ["Spray Bottle", "Shovel", "Light Hose", "Rain Boots"],
        garage: ["Audi", "Tool Box", "Rake"],
        guest_room: ["Car Keys", "TV", "Remote Control", "Lamp", "Book"],
        kitchen: ["Pots", "Spatula", "Knives", "Plates", "Refridgerator",
          "Deep Freezer", "Apron", "Coffee Machine", "Fruit Bowl", "Juicer"],
        study: ["Book Case", "Reading Lamp", "Office Chairs", "Computer",
          "Message Table", "Water Station", "World Globe", "Boat Model"],
        dining_room: ["Wine Glasses", "Table Leaf Bags", "Bench, Settee",
          "Wall Shelves", "Lazy Susan", "Valances", " China Cabinets",
          "Host Chairs", "Wall Clock", "Artwork", "Posters", "Candle Holders",
          "Boxes", "Napkins", "NapkinRings", "Buffet Lamps", "Water Vases",
          "Trays", "Crystal Glassware"],
        living_room: ["Moroccan Rug", "Coffee Table", "Bold Drapes",
        "Curved TV", "Comfy Pillows", "Throw Blankets"]
     }
  end

  defp explored_rooms do
    Agent.get(ExploredRooms, &(&1))
  end

  defp unexplored_rooms do
    Agent.get(UnExploredRooms, &(&1))
  end

  defp room_check_count do
    Agent.get(RoomCheckCount, &(&1))
  end

  defp start_exploring_rooms do
    Agent.start(fn() -> [] end, [name: ExploredRooms])
    start_room_check_count
  end

  defp start_unexplored_rooms_list do
    Agent.start(fn() -> Map.keys(house) end, [name: UnExploredRooms])
  end

  defp start_room_check_count do
    Agent.start(fn() -> 0 end, [name: RoomCheckCount])
  end

  defp expand(room) when is_atom(room) do
    Agent.update(UnExploredRooms, fn(list) -> List.delete_at(list, -1) end)
    Agent.update(ExploredRooms, fn(list) -> List.insert_at(list, 0, room) end)
    Agent.update(RoomCheckCount, fn(current_count) -> current_count + 1 end)
  end

  defp find_in_room(item) do
    Enum.map(unexplored_rooms, &look_for(item, &1))
  end

  defp look_for(item, room) do
    room_items = Map.get(house, room)
    if item in room_items do
      IO.puts("Found the #{item} in the #{Atom.to_string(room)}")
      IO.puts("My search path before the item was found..")
      Enum.each(Enum.reverse(explored_rooms), &IO.puts(&1))
      IO.puts("It took a total of #{inspect(room_check_count)} room checks before item was found!")
    else
      expand(room)
    end
  end
end

BreadthFirst.search({:master_bedroom, "Wallet"})
