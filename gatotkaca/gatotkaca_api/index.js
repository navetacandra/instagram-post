const { parse: uriParse } = require("url");
const cheerio = require("cheerio");
const express = require("express");
const bodyParser = require("body-parser");
const fetch = (...args) =>
  import("node-fetch")
    .then(({ default: f }) => f(...args))
    .catch((err) => console.log(err));

const app = express();

async function getHTML(url = "https://example.com/") {
  try {
    const res = await fetch(url);
    const html = await res.text();
    return html;
  } catch (err) {
    return "<html></html>";
  }
}

function parseResult(html = "<html></html>") {
  const $ = cheerio.load(html);
  return $(".Gx5Zad.fP1Qef.xpd.EtOod.pkphOe")
    .map((i, el) => {
      let url = $(el).find("a").attr("href");
      let title = $(el).find("h3").text();
      let description = $(el)
        .find(".kCrYT .BNeawe.s3v9rd.AP7Wnd .BNeawe.s3v9rd.AP7Wnd")
        .remove("span")
        .text();

      if (url.startsWith("/url?q=")) url = `https://www.google.com${url}`;
      url = new URLSearchParams(
        uriParse(url).search.substring(uriParse(url).search.indexOf("?"))
      ).get("q");

      return { url, title, description };
    })
    .toArray();
}

async function search(query = "") {
  const url = `https://www.google.com/search?q=${encodeURIComponent(
    query
  )}&start=0&sa=N&num=100&ie=UTF-8&oe=UTF-8&gws_rd=ssl`;
  const html = await getHTML(url);
  const result = await parseResult(html);
  return result;
}

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get("/search", async (req, res) => {
  const query = req.query.q || req.body.q;
  // Maintenance response
  // return res.status(408).json({ message: "Server in maintenance." });
  if (!query) {
    return res.status(400).json({ message: "Parameter required." });
  } else {
    try {
      const searchResult = await search(query);
      return res.status(searchResult.length ? 200 : 404).json(searchResult);
    } catch (err) {
      console.log(err);
      return res.status(500).json({ message: err });
    }
  }
});


const PORT = process.env.PORT || 80;
app.listen(PORT, () => console.log(`Running  in PORT: ${PORT}`));
