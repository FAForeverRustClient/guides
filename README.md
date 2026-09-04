# FAF training catalogue

The guides, videos, build orders and trainers that the FAF client's **Training**
tab shows. One file is the whole contract: [`catalogue.json`](catalogue.json).

Nothing here needs a client release. Adding a guide, retagging one, adding a
trainer or changing the training Discord invite is a commit, and it reaches
every client on its next load.

The client reads it from
`https://raw.githubusercontent.com/FAForeverRustClient/guides/HEAD/catalogue.json`.

---

## Submitting a guide

**From the client.** Training tab, "Submit training material". Fill in the
title, the one-line description and the tags, then either write the guide there
or link to a video or page. The client opens an issue here with everything a
maintainer needs, so accepting it is one press.

**By hand.** Open an issue with the *Training submission* template. It contains
the same block the client writes; fill in the values and a maintainer can accept
it the same way. An issue without that block is still read and still answered,
it just has to be turned into a catalogue entry by hand first.

Either way the issue needs the `training-submission` label, which both paths
add for you.

## What makes a good submission

The tags matter as much as the content, because they are what lets the right
player find it:

- **Rating range.** Who is this for? "Everyone" is almost never true, and a
  guide aimed at nobody in particular is recommended to nobody in particular.
- **Game modes and maps.** Leave them off if the guide is about the game rather
  than about one queue or one map; that is not a gap, it is an answer.
- **Topic.** One of the ten the catalogue knows. If none fits, say so in the
  issue rather than forcing one.
- **A one-line description.** It is what a card in the library shows under the
  title, and it is the sentence that decides whether anybody opens the guide.

## Maintaining it

Whoever can commit here decides. Accepting from the client commits the guide
file (when the author wrote one), adds the entry to `catalogue.json`, comments
where it landed and closes the issue. GitHub enforces the permission: the client
draws the buttons for anyone signed in and a commit from a non-collaborator is
refused, so adding a trainer to the team is `Settings > Collaborators` and
nothing else.

Declining takes a reason from a fixed set plus an optional note, and both go
into the issue where the author reads them. That is the part that decides
whether they submit again.

`validate.yml` checks every pull request: the document parses, ids are unique,
`related` resolves, and links are `https://`. The client is deliberately
forgiving at runtime (a typo in a field name loses that field rather than
sinking the whole document), which is right for a player and wrong for a review.

## Layout

```
catalogue.json    the manifest the client reads
guides/           long-form guides, one Markdown file each
```

A guide written in the client is committed to `guides/<id>.md` when it is
accepted, and its catalogue entry points at the raw address of that file. A
guide that lives on YouTube or the wiki is just a `url` and no file.

## Format

Every field, with its meaning and its allowed values, is documented in
[`docs/training-catalogue.md`](https://github.com/FAForeverRustClient/FAForeverRustClient/blob/develop/docs/training-catalogue.md)
in the client repository, next to the code that reads it.

The short version:

```json
{
  "links": { "discordUrl": "...", "replayReviewCategory": 4, "wikiUrl": "..." },
  "trainers": [
    { "name": "Someone", "fafId": 101, "role": "Personal trainer",
      "topics": ["economy"], "gameModes": ["1v1"],
      "ratingMin": 1000, "ratingMax": 1800,
      "languages": ["English"], "discord": "someone", "accepting": true }
  ],
  "resources": [
    { "id": "setons-t1-build-order",
      "title": "Seton's Clutch T1 build order",
      "summary": "Four mexes, then land.",
      "kind": "buildOrder",
      "level": "beginner",
      "url": "https://...",
      "ratingMin": 700, "ratingMax": 1200,
      "gameModes": ["4v4"], "topics": ["buildOrder", "economy"],
      "maps": ["Setons Clutch"], "factions": ["uef"],
      "related": ["economy-fundamentals"] }
  ]
}
```

`kind` is one of `video`, `guide`, `buildOrder`, `replayAnalysis`, `lesson`,
`community`. `level` is `beginner`, `intermediate` or `advanced`. `topics` come
from a closed set: `economy`, `buildOrder`, `micro`, `strategy`,
`armyComposition`, `mapControl`, `scouting`, `factions`, `teamplay`,
`interface`.
