.pragma library

// The configured address is a server origin, not an arbitrary request URL.
function baseUrl(value) {
  var address = String(value || "").trim();
  if (!/^https?:\/\/(?:\[[0-9a-f:.]+\]|[a-z0-9._-]+)(?::[0-9]{1,5})?\/?$/i.test(address))
    return "";
  return address.replace(/\/$/, "");
}

function pageUrl(base, path) {
  if (!base || !/^\/(?:[a-z0-9/?#=&-]*)$/i.test(path)) return "";
  return base + path;
}

function reviewPlan(raw) {
  var plan = JSON.parse(raw);
  var due = plan && plan.summary && plan.summary.due_questions;
  if (typeof due !== "number" || !isFinite(due) || due < 0 || Math.floor(due) !== due)
    throw new Error("Invalid due-question count");
  var items = Array.isArray(plan.items) ? plan.items : [];
  var recommendations = [];
  for (var i = 0; i < items.length && recommendations.length < 2; i++) {
    var item = items[i];
    if (item && typeof item.title === "string" && item.title.trim())
      recommendations.push(item.title.trim().slice(0, 100));
  }
  return { due: due, recommendations: recommendations };
}
