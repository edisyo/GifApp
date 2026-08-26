# Gif App
Is a Flutter app made for Android and iOS, that utilizes GIPHY API to display GIF's using their Search and Trending Endpoints.

Developed using Flutter 3.44.9 and Dart 3.12.2

Developed in VS Code on Windows and Mac, 
for version control used Git
# Setup

1. Get GIPHY's API key (not SDK) here - https://developers.giphy.com/dashboard/?create=true
2. Clone this repository
3. Open it in VS Code
4. Create a `giphy.json` in `env` folder
	1. Look at the example inside `env`
	2. Copy and paste into `giphy.json`
	3. Replace the placeholder with your key
```dart
{
	"GIPHY_API_KEY": "place_your_key_here"
}
```
5. Run project from terminal: 
   ```dart
   flutter run --dart-define-from-file=env/giphy.json
   ```
6. Optional - if project is opened with VS Code and ran with VS Code debugger (F5) 
	1. Add this line to each configuration in `.vscode/launch.json`.
   ```json
   "toolArgs": ["--dart-define-from-file=env/giphy.json"]
   ```
	So the configuration looks like this:
   ```json
   {
	   "name": "gif_app",
	   "request": "launch",
	   "type": "dart",
	   "toolArgs": ["--dart-define-from-file=env/giphy.json"]
	}
   ```

---
# Architecture

Three main layers:
1. **Screens**      widgets - draw states, send events
2. **Bloc**        holds state and decides what the screen should show
3. **Data**        Gif model, repository and api client

This makes sure that dependencies point only one way: Screens → Bloc → Data.  Each Layer knows only about the one below it.
For example, the search page has no import path to network layer. It doesn't see the API calls and doesn't process the data. Each Page's job is only to show the data in the UI. And the data gets passed down using Bloc States.

The payoff? Swap Giphy for a local database and only the data layer changes. Thats why one-way rule matters.

# Main features

### Search

The search fires on its own after the user stops typing for 750ms — there's no search button. Every keystroke cancels a timer and starts a new one, so only the last one actually runs. I picked 750ms because it felt right when typing at a normal speed, and it also keeps the app under Giphy's 100 calls per hour limit on a beta key.

One thing I ran into: if the user types fast on a slow connection, two requests can be running at the same time, and they don't always come back in order. So a slow request for "ca" could land after a fast one for "cats" and overwrite the correct results. I fixed this with `restartable()` from `bloc_concurrency`, which cancels the old request when a new one starts.

The loaded state carries the gifs **and** the query together. I originally had the results label reading the search box directly, and realised the label could say "cats" while the grid showed results for "ca" — so the screen would look fine even when it was wrong. Now both come from the same state object, so they can't disagree.

### Pagination

New gifs load when the user scrolls within 200px of the bottom, not right at the bottom. That way the next page is usually loaded before the user gets there, and the grid just keeps going.

The scroll listener fires constantly while scrolling, so my first version sent about twenty requests at once. I guard against it in two places: `droppable()` ignores new events while one is already running, and the handler returns early if it's already loading.

New gifs get added to the existing list instead of replacing it — the state holds a `List<Gif>` rather than one page, since the screen shows everything loaded so far. To know when to stop, I check whether fewer gifs came back than I asked for. I'd originally used `total_count`, but noticed Giphy always returns 500 even for huge searches, so it seems to be a cap rather than a real number.

If loading an extra page fails, the gifs already on screen stay there instead of everything switching to an error screen. Losing 50 loaded gifs because page 3 failed seemed worse than the failure itself.

### Trending

Trending uses the same bloc class as search, with a flag for which endpoint to call. I did think about writing a separate bloc, but the pagination, offset tracking and end detection would have been copied almost line for line. Each tab gets its own instance, so they don't share state.

### Navigation

Both tabs live in an `IndexedStack`, which keeps them both alive instead of rebuilding them each time you switch. That way the search results and scroll position are still there when the user comes back. The downside is that trending loads at startup even if the user never opens it, but that's one API call so it seemed like a fair trade.

Navigation uses `go_router` with all the routes in one file. The search page doesn't import the detail page at all — it just pushes a route and doesn't know what's on the other side.

# What I didn't finish

### Network availability handling

This was on the bonus list and I didn't get to it. The plan was `connectivity_plus` to show an offline banner and disable searching while there's no connection.

The app does already handle failed requests — a `NetworkException` is thrown and shown on screen — so it doesn't crash offline, it just doesn't warn the user beforehand. 

# What would I improve

### Rendition fallback

Right now I pick two specific renditions from Giphy's response — a small one for the grid and a bigger one for the detail view — and fall back to an empty string if they're missing. I checked about hundred gifs across different searches and never saw them missing, so I left it.

If I did hit it, my plan was two ordered lists of rendition names, taking the first one that isn't null. Smallest suitable first for the grid, largest suitable first for the detail view. I'd order them by hand rather than sorting by file size, since the smallest file isn't necessarily the right one for a full screen view.

### Snackbar for failed pagination

When an extra page fails to load, the grid stays but the user isn't told anything about it. It's a silent failure. I'd add a `BlocListener` showing a snackbar — a listener rather than a builder, since a snackbar is a side effect and not something the screen is displaying.

### Detail screen fetching by ID

The detail screen currently gets its data from the gif object passed to it from the grid. Giphy has a "get GIF by ID" endpoint that returns more information, and that would be the better version — it would also make deep links work, since right now I pass the whole object through `go_router`'s `extra`, and a pasted URL wouldn't carry it.

---

If you have no `launch.json`. Here is the full file
```dart
{	
	"version": "0.2.0",
	
	"configurations": [
	
		{
			"name": "gif_app",
			"request": "launch",
			"type": "dart",
			"toolArgs": ["--dart-define-from-file=env/giphy.json"]
		},
	
		{
			"name": "gif_app (profile mode)",
			"request": "launch",
			"type": "dart",
			"flutterMode": "profile",
			"toolArgs": ["--dart-define-from-file=env/giphy.json"]
		},
	
		{
			"name": "gif_app (release mode)",
			"request": "launch",
			"type": "dart",
			"flutterMode": "release",
			"toolArgs": ["--dart-define-from-file=env/giphy.json"]
		}
	]
}
```
