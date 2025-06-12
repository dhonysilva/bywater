# Bywater

Is a simple application where I can play with the Release Candidate of Phoenix Framework, 1.8.0-rc.

At this point, I am really interested on learn about the Scopes. Here is the [Guide](https://hexdocs.pm/phoenix/1.8.0-rc.0/Phoenix.Scope.html). As by the release post, "Scopes provide a foundation for building multi-tenant, team-based, or session-isolated apps, slot cleanly into the router and LiveView lifecycle".

I am using this application to walk through the these possibilies.

### Bywater origin's name

Bywater is a fictional town in Middle-earth, located in the Shire. It is the home of Bilbo Baggins and Frodo Baggins, and is the setting for J.R.R. Tolkien's The Hobbit and The Lord of the Rings.

Click [here](https://tolkiengateway.net/wiki/Bywater) to learn more.

## Instalation

To run this application:

* Run `mix setup` to install and setup dependencies. This will create SQLite database and run the migrations.
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

1 - Register a new user. Remember this application is using the Magic Link Authentication.

1.1 - Once authenticated, go to `/organizations/` to see your standard Organization called Personel.

2 - Create a new organization.These organizations belongs to the user via the organization membership.

3 - Click on each organization to see the details. There's an inspect showing the Scope details (`assigns.current_scope`).

## Learn more

This application is using the Scopes feature of Phoenix Framework. Scopes provide a foundation for building multi-tenant, team-based, or session-isolated apps, slot cleanly into the router and LiveView lifecycle. I've being using the references bellow to study this topic:

* Official [Scope Documentation](https://hexdocs.pm/phoenix/1.8.0-rc.3/scopes.html)
* [Implementing Multi-Tenancy in Phoenix 1.8 - Single vs Multi-Organization Approaches](https://github.com/ZenHive/OrgsDocs/blob/main/multi_org/authorization_strategy.md)
* [ElixirForum - Implementing Multi-Tenancy in Phoenix 1.8 - Single vs Multi-Organization Approaches](https://elixirforum.com/t/implementing-multi-tenancy-in-phoenix-1-8-single-vs-multi-organization-approaches/70301)

Daniel Bergholz just release an awesome video talking about Scopes in Phoenix. Check it out here:

[![alt text](https://img.youtube.com/vi/1rig662q424/sddefault.jpg)](https://www.youtube.com/watch?v=1rig662q424)
