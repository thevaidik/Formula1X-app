# Formula1X Design Language

## Concept: 1980s Retro Motorsport Editorial
The aesthetic of Formula1X is heavily inspired by 1980s motorsport magazines, racing posters, and editorial graphic design. It prioritizes bold typography, stark geometric color blocking, and a deliberate absence of modern soft gradients or drop shadows. 

The goal is to create an interface that feels raw, physical, and highly stylized—like a vintage Formula 1 almanac brought to life on an iOS screen.

---

## 1. Color Palette
We avoid generic iOS colors and stick to a highly specific, curated vintage palette.

- **Background (Off-Black):** `#121212` 
  *Used as the stark, infinite canvas for all views.*
- **Salmon Pink:** `#E3908C`
  *Primary accent. Used for major calls to action, active tabs, and primary data highlights.*
- **Mustard Yellow:** `#DDA23B`
  *Secondary accent. Used for progress bars, secondary highlights, and caution/warning states.*
- **Olive Green:** `#A0A87A`
  *Tertiary accent. Used for massive navigational blocks (like the LATEST NEWS button).*
- **Deep Red:** `#C34242`
  *Impact accent. Used sparingly for critical dates, next race countdowns, or extreme emphasis.*
- **Light Grey / Off-White:** `#CDCACA`
  *Primary text color. Avoid pure `#FFFFFF` white to maintain the vintage print feel.*

## 2. Typography
Typography is the primary structural element of the application. 

- **Modifier:** `.fontWidth(.condensed)` is strictly enforced on all major headers.
- **Font Style:** We utilize heavy, blocky system fonts (`.system(weight: .black, design: .rounded)`) combined with the condensed width to mimic vintage racing typefaces.
- **Capitalization:** ALL CAPS is used almost exclusively for headers, locations, driver names, and dates. Lowercase is strictly reserved for paragraph text (like news article bodies).
- **Custom Modifier:** The app uses a custom `retroFont(size:isTitle:)` view modifier to easily apply this typography stack anywhere in the codebase.

## 3. UI Components & Layout
- **No Floating Cards:** Avoid modern iOS floating cards with drop shadows. Elements should feel like flat "blocks" of color printed on a page.
- **Uneven Rounded Rectangles:** Use `UnevenRoundedRectangle` to create asymmetrical, sharp shapes. For example, a card might have rounded top corners but sharp bottom corners.
- **Heavy Borders:** When elements aren't solid color blocks, they can use thick (2px - 4px) solid borders.
- **Minimal Imagery:** Avoid generic photography (like placeholder cars). Use abstract geometric shapes (circles, lines) or highly stylized, subtle icons (like `flag.checkered`) to represent concepts.
- **Vertical Flow:** The layout relies on heavy vertical scrolling with massive, edge-to-edge structural blocks rather than horizontally scrolling carousels.

## 4. Widgets
- Widgets follow the exact same rules but are completely independent of system light/dark mode by utilizing a hardcoded `WidgetTheme` struct to guarantee the colors remain stark and consistent.
- The UI must rely heavily on condensed typography and stark color intersections (e.g., a deep red date block intersecting an olive green location block).
