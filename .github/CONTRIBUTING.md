# Verde Contribution Guidelines
Thanks for taking the time to look at how you can contribute to Verde.
We appreciate each and every one of our contributors for volunteering to make Verde better for the community.

## ❔ How to contribute?
You may think contributing is solely related to feature development but that is not the case. Contributions can come in many forms

### ✨ Enhancements
Making enhancements or developing new features for the project can massively speed up development in more key areas.
If you see any open issue or feature on the Kanban board that currently has nobody assigned you can begin work on the feature and create a pull request for review.

Please ensure you follow our [📝 Code Styling](#-code-styling) guidelines as well 

### 🐛 GitHub Issues
Creating or commenting on issues or RFCs and providing your own opinion *[within community guidelines](./CODE_OF_CONDUCT.md)* can provide us with insight into how to
tailor development for Verde in the future and prioritise certain areas for development.

Before you make an issue it is important to make sure that no issue has already been made.
> If you find an issue that has been **Closed** please create a new issue, and within the body provide a link to the previously closed issue.
> This will allow us to determine if this is a regression and can take the necessary steps to analyse any changes made to that area.

### 📗 Documentation
If you notice any area of the documentation that requires improvement, 
be it a spelling mistake or an undocumented API, making changes or an issue in GitHub to notify us can help the wider community better understand the project.

For documentation changes please follow the recommendations made in the [✨ Enhancements](#-enhancements) section, as this will require a pull request.
Otherwise, if you plan on making an issue to notify us of a change to be made please follow the recommendations in the [🐛 GitHub Issues](#-github-issues) section.

## 📝 Code Styling
This repository contains at a base level two individual programming languages for the individual components of Verde.
It's necessary that the code you write can be well understood and fits into the rest of the project's styling.
> 💡 Remember, you write code once and will you often read it multiple times. 

### Rust (CLI)
This is arguably the most important part of Verde and is what makes the whole file syncing possible.
We have set up Rustfmt to ensure we abide by the [Rust style guide](https://doc.rust-lang.org/beta/style-guide/index.html), 
and all queries related to the style guide should be first consulted with the aforementioned link.

#### Documentation
It is important to note that we expect your code to be well documented with comments and Rustdoc
```rust
/// Handles timekeeping
/// ```rs
/// let stopwatch = Timer::new(60)
/// ```
struct Timer { ... }
```
Rustdoc supports markdown and we expect good formatting and examples where applicable so that end-users and reviewers can easily understand the purpose
of a new API.

You can read more about Rustdoc and how to use it [here](https://doc.rust-lang.org/rustdoc/index.html).

### Luau (Plugin)
Currently, the only Luau code is localised within the Roblox Studio plugin.
When writing Luau please follow the [Roblox Lua Style Guide](https://roblox.github.io/lua-style-guide/).
