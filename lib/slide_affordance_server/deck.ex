defmodule SlideAffordanceServer.Deck do
  @no_caption "No caption"

  defmodule DeckData do
    @moduledoc """
    current slide number, list of slide number-slide caption tuples, max number of slides.
    """

    defstruct slide_number: 1, captions: [], max: 999
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(_opts) do
    {:ok, pid} = Agent.start_link(fn -> %DeckData{captions: captions() |> tuples_to_array(), max: 226} end)
    Process.register(pid, :deck)
    {:ok, pid}
  end

  def current do
    Agent.get(:deck, fn data -> get_caption(data) end)
  end

  def forward, do: Agent.update(:deck, &forward/1)

  defp forward(deck = %{slide_number: num, max: max}) when num == max, do: deck

  defp forward(deck = %{slide_number: num}), do: %{deck | slide_number: num + 1}

  def back, do: Agent.update(:deck, &back/1)

  defp back(deck = %{slide_number: num}) when num == 1, do: deck

  defp back(deck = %{slide_number: num}), do: %{deck | slide_number: num - 1}

  def reset do
    Agent.update(:deck, fn deck -> %{deck | slide_number: 1} end)
  end

  @spec tuples_to_array(list({integer, String.t()})) :: list(nil | String.t())
  defp tuples_to_array(tuples) do
    Enum.reduce(tuples, [], fn {index, caption}, acc -> List.insert_at(acc, index, caption) end)
  end

  defp get_caption(%{slide_number: slide_number, captions: captions}), do: get_caption(slide_number, captions)
  defp get_caption(num, _captions) when num < 1, do: @no_caption
  defp get_caption(num, captions), do: Enum.at(captions, num, get_caption(num-1, captions))

  defp captions do
    [
      {1, "The Test at the Table and the Tester in my Head with Adrian P. Dunston. Twitter: @bitcapulet"},
      {2, "Story time"},
      {3, "photo of James Dooley"},
      {4, "Adrian making a silly grumpy face."},
      {5, "Adrian making a silly smug face."},
      {6, "Adrian P. Dunston (he/him) Email: adrian@bitcapulet.com Twitter: @bitcaulet A picture of colored markers in random order."},
      {7, "Same markers but subtle color changes making them look ordered."},
      {8, "Spread a quality mindset"},
      {9, "maker"},
      {10, "making"},
      {11, "made"},
      {12, "A why and four hows"},
      {13, "Computer Science is no more about computers than astronomy is about telescopes. - Edsger Dijkstra"},
      {14, "cartoon people"},
      {19, "question marks"},
      {20, "hearts"},
      {21, "storm clouds"},
      {22, "Software quality is not about lack of bugs. Quality software is about making users into badasses. Kathy Sierra"},
      {23, "Quality is a form of love."},
      {24, "Cartoon people with words maker, making, and made"},
      {27, "Spread a quality mindset; with four hows"},
      {28, "Cartoon people"},
      {31, "photo of Angie Jones. Twitter: @techgirl1908"},
      {32, "a brain"},
      {36, "a giant cartoon ant"},
      {37, "Ant: Hiya! I'm Sidney."},
      {38, "Ant: Because ants are amazing!"},
      {39, "And maybe because you told your artist to have fun with this one."}
    ]
  end
end
