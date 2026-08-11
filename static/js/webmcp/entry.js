// WebMCP registration scope for vladikk.com.
//
// One batch, registered on every page load. The site is a static MPA, so a full
// page navigation tears the registration down and the next page re-registers;
// pagehide covers bfcache and same-tab navigation.
//
// registerTools is a graceful no-op in browsers with no WebMCP surface.

import { registerTools } from "@agentlane/webmcp";
import { askSite } from "./tools/site.js";

const registration = registerTools([askSite]);

addEventListener("pagehide", () => registration.unregister(), { once: true });
