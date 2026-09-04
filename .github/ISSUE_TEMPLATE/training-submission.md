---
name: Training submission
about: Add a guide, video or build order to the FAF training catalogue
title: 'Training submission: '
labels: training-submission
---

<!--
Submitting from the FAF client (Training tab, "Submit training material") fills
all of this in for you. This template is the same thing by hand.

Keep the two blocks below intact. A maintainer can then accept the submission in
one press; without them it has to be turned into a catalogue entry by hand
first, which is slower for everybody.
-->

Replace this line with one or two sentences on what the guide is and who it
helps.

<!-- If the guide lives somewhere else (YouTube, the wiki, the forum), delete
     the block below and put the address in "url" instead. -->

<!-- guide:begin -->
## Write the guide here

Markdown. Headings, lists, code blocks and links all work.
<!-- guide:end -->

<!-- The block below is what the FAF client reads. Edit the values, keep the shape. -->

```json
{
  "id": "a-short-hyphenated-id",
  "title": "The title as a reader sees it",
  "summary": "One line. This is what a card in the library shows.",
  "kind": "guide",
  "level": "beginner",
  "url": "",
  "author": "Your FAF name",
  "ratingMin": null,
  "ratingMax": null,
  "gameModes": [],
  "topics": [],
  "maps": [],
  "factions": [],
  "related": []
}
```

<!--
kind      video | guide | buildOrder | replayAnalysis | community
level     beginner | intermediate | advanced   (or delete the line)
topics    economy, buildOrder, micro, strategy, armyComposition,
          mapControl, scouting, factions, teamplay, interface
gameModes free text: "1v1", "4v4", "coop", a mod's own queue
maps      map names as a player writes them: "Setons Clutch"
factions  uef, aeon, cybran, seraphim

Leave gameModes and maps empty when the guide is about the game rather than
about one queue or one map. That is an answer, not a gap: an entry claiming no
map is shown to everybody, and one claiming a map is shown first to the people
playing it.
-->
