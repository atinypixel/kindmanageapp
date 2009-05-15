# Kindmanage

It's a dead simple project management app built with Ruby on Rails. It borrows a lot of philosophies from existing apps such as Twitter, Facebook, Basecamp, Gmail and several others. Kindmanage focuses on communication first and foremost during the lifespan of a project.

## Features

Projects have entries which are then categorized as notes, tasks or what have you. All features are still being worked out. However, some features just need explanation.

### Workspaces

Whether you work with a project individually or with a team, managing the varying priorities of project-related data such as notes, tasks, etc can be difficult and time consuming. This is Kindmanage's primary problem domain. Workspaces makes an attempt to solve it.

As a web designer I typically am working on several projects at a time. Every note, task and shared document among those projects have a specific priority while others may not have any at all. With workspaces, I can take a task or note from project **A**, **B** and or **X** and stream them to a workspace by way of hash tag.

Essentially kindmanage will extract each hash tag from an entry and create or find workspaces based on those hash tags. Kindmanage will then take each workspace and bind it to a project entry. When you go to view a given workspace, it will show all the "collected" entries for that workspace.

But if you decide to remove a hash tag or several hash tags from a project entry, Kindmanage will also automatically remove the corresponding collection.