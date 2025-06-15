# What is this?
A basic website scraper/crawler. Right now, a lot of the customization is loaded into the first lines of the powershell scripts. If you want to change things, just whip out a text editor.
I'll pretty soon be moving much of the customization (like, for example, what website you want to scrape) to the .env file instead, but this is the way it is for now.

# Why do this?
- Because I'm ungodly tired of having to poke around 20 links to find the one I'm thinking of.
- Because I'm really curious what percent of the website I've actually explored.
- Because I've been wanting to write a simple crawler for a while. 
- - A while is like a week lol

# Checkpoints.txt?
Some websites have pages that aren't accessible via any clickable links on the site. That means it's impossible for the scraper to find them!
Pages like those can be added to checkpoints.txt, and the crawler will include them in its search as if they were standard pages.

# sitemap.xml?
Well, I've gotta save the results of the script somewhere. That's (by default) where.

# Is this a zero day exploit?
People like you trigger me.. I'll ignore it.

# Wait hold on did you say .env
lol