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
    deck_data = %DeckData{captions: captions() |> tuples_to_map(), max: 226}
    {:ok, pid} = Agent.start_link(fn -> deck_data end)
    Process.register(pid, :deck)
    {:ok, pid}
  end

  def current do
    Agent.get(:deck, fn data -> get_caption(data) end)
  end

  def slide_number, do: Agent.get(:deck, fn %{slide_number: num} -> num end)

  def forward, do: Agent.update(:deck, &forward/1)

  defp forward(deck = %{slide_number: num, max: max}) when num == max, do: deck

  defp forward(deck = %{slide_number: num}), do: %{deck | slide_number: num + 1}

  def back, do: Agent.update(:deck, &back/1)

  defp back(deck = %{slide_number: num}) when num == 1, do: deck

  defp back(deck = %{slide_number: num}), do: %{deck | slide_number: num - 1}

  def reset do
    Agent.update(:deck, fn deck -> %{deck | slide_number: 1} end)
  end

  @spec tuples_to_map(list({integer, String.t()})) :: map
  defp tuples_to_map(tuples) do
    Enum.reduce(tuples, %{}, fn {index, caption}, acc -> Map.put(acc, index, caption) end)
  end

  defp get_caption(%{slide_number: slide_number, captions: captions}), do: get_caption(slide_number, captions)
  defp get_caption(num, _captions) when num < 1, do: @no_caption
  defp get_caption(num, captions), do: Map.get(captions, num, get_caption(num-1, captions))

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
      {39, "And maybe because you told your artist to have fun with this one."},
      {40, "Section 1. Listen to QA. They're experts in their field."},
      {41, "What do testers do?"},
      {42, "Ant: He's going to say we break things."},
      {43, "Ant: We do not break things."},
      {44, "Ant: Mysteries..."},
      {48, "developer and tester"},
      {49, "lone developer"},
      {50, "user"},
      {51, "All software is collaboration."},
      {52, "Users are the least qualified, most expensive testers."},
      {53, "Developer brings optimism. Tester brings skepticism."},
      {56, "Quality is the hidden ingredient in all of our products. But it’s consumed just like everything else. -Mike Baldwin"},
      {57, "QA Professionals help create software"},
      {58, "Ant: And..."},
      {59, "Ant: I mean throw a bullet on that and give me three more."},
      {60, "QA professionals. 1. Help create software"},
      {61, "2. Keep the mental model of the product"},
      {62, "3. Advocate for users"},
      {63, "4. Act as morale centers"},
      {64, "Team morale seems to directly correlate with software quality. -Jenny Bramble"},
      {65, "Ant: Now tell dear listeners what they should be doing."},
      {66, "Subheading: Listen on purpose"},
      {67, "Story time"},
      {68, "Ant: You don't say"},
      {69, "company hierarchy: top = sociopaths, middle = clueless, bottom = losers"},
      {70, "cartoon business-person listening to a developer"},
      {71, "Movie posters: Tron, War Games, Hackers, The Matrix"},
      {76, "Developer with three dollars. Tester with two."},
      {77, "Ignoring QA's expert advice is a dangerous norm across industries."},
      {78, "Listen on purpose"},
      {79, "Give them space to talk"},
      {80, "Tester: The new feature's broken in the test environment."},
      {81, "Developer thought: Works on my machine"},
      {82, "Developer: What's the behavior you're seeing?"},
      {83, "Ask them to weigh in"},
      {84, "Manager: Are we good on this?"},
      {85, "3 Developers: Yes."},
      {86, "Manager: QA, what are we missing?"},
      {87, "Accept their influence"},
      {88, "Manager: I don't want to spend the manpower on spinning up a new QA environment."},
      {89, "QA: Did you read the risk assessment?"},
      {90, "Manager: Yes, I'll do it. ...I just don't want to."},
      {95, "Section 2: Amplify QA's voice"},
      {96, "Story time"},
      {97, "Surprised Pikachu"},
      {98, "Grumpy face"},
      {99, "Smug face"},
      {100, "Developer in a group repeating tester's words"},
      {101, "Cartoon people"},
      {102, "Ant: Show that onew again"},
      {103, "Terrifying Ant: Show it again!"},
      {104, "I'll grab QA so we can discuss it."},
      {106, "Ant: Thank you"},
      {107, "Subheading: Find the catch-phrases"},
      {109, "Nothing hard is ever easy"},
      {110, "Even a blind pig finds an acorn once in a while."},
      {111, "Yeah? And if my grandmother had wheels, she'd be a stagecoach."},
      {113, "You explain. I decide."},
      {114, "That looks complicated. It would be a shame if a user were to mess with it."},
      {115, "That's why we have checklists."},
      {116, "Nobody will buy half the store. But if they do, you'll want your register working."},
      {117, "Jenne Hesse saying 'Prove it.'"},
      {118, "How do we know it's working? Might be a load-bearing bug. If it were broken in production, how would we know? You support me, and I keep you safe. Don't feed the test-matrix. It's OUR job to make quality software."},
      {119, "Cartoon people"},
      {126, "Developer with terrifying ant"},
      {127, "Subheading: Find the stories"},
      {132, "Simple, unexpected, emotional"},
      {138, "Terrifying ant: Then she crushed you for your impudence!"},
      {140, "Alaska"},
      {143, "Remember that time we didn't point-in the risk and all had to stay all night?"},
      {144, "How is this different?"},
      {146, "Repeat them. Go get them. Catch-phrases. Stories"},
      {148, "Section 3 Walk the walk"},
      {149, "Subheading: Respect their property"},
      {150, "A play about bug tickets"},
      {151, "Adrian's thought bubble"},
      {152, "Ant: Ahem..."},
      {153, "Ant: And why not?"},
      {154, "Ant: Correct, they belong to your tester."},
      {155, "Ant: Remember what Julia said. You explain, she decides."},
      {157, "Ant: If you value your safety"},
      {158, "Ant: Like I said, she decides."},
      {159, "Property of QA: Bug tickets, QA Environments, Test plans"},
      {160, "Subheading: Remove obstacles"},
      {161, "Developer with baseball flying at forehead"},
      {167, "Tester catches baseball."},
      {168, "Verification Fatigue"},
      {169, "Fit and finish. Developer ignoring a pile of baseballs."},
      {172, "Tester goes to address pile."},
      {176, "Large baseball flies at developer's head"},
      {180, "Environmental support"},
      {181, "Tester goes to address broken computer"},
      {188, "Large baseball flies at developer's head"},
      {192, "Pairing"},
      {193, "Developer and tester working together"},
      {198, "Developer and tester at tester's workstation"},
      {202, "Subheading: Deal with your emotions"},
      {203, "A play about reactions"},
      {204, "Adrian's thought bubble"},
      {205, "Ant: Is she wrong?"},
      {206, "Ant: Well I can't imagine why she'd report them."},
      {207, "Ant: That's valid. It's been a tough sprint."},
      {208, "Ant: So what are you going to tell your tester?"},
      {212, "Section 4: Make a deal"},
      {213, "Developer brings optimism. Tester brings skepticism."},
      {214, "Story time"},
      {215, "Dev supports QA, and QA keeps Dev safe."},
      {221, "List of sections"},
      {222, "Ant: That's some solid talking, Adrian."},
      {223, "Ant: Bring it home"},
      {224, "Cartoon people"},
      {225, "Thank you! Art by Gabriel Dunston. Template by Slides Carnival. Content by Adrian P. Dunston. Twitter: @bitcapulet Email: adrian@bitcapulet.com"}
    ]
  end
end
