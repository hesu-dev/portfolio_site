export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Flutter에서 __path로 원래 API path를 넘김
    const path = url.searchParams.get("__path");
    if (!path) {
      return new Response("Missing __path", { status: 400 });
    }
    url.searchParams.delete("__path");

    // apis.data.go.kr로 포워딩
    const target = new URL("https://apis.data.go.kr" + path);
    for (const [k, v] of url.searchParams.entries()) {
      target.searchParams.set(k, v);
    }

    const resp = await fetch(target.toString(), { method: "GET" });

    // CORS 헤더 부여 (웹에서 안전)
    const headers = new Headers(resp.headers);
    headers.set("Access-Control-Allow-Origin", "*");
    headers.set("Access-Control-Allow-Methods", "GET, OPTIONS");
    headers.set("Access-Control-Allow-Headers", "Content-Type");

    // 그대로 반환
    return new Response(resp.body, { status: resp.status, headers });
  },
};
