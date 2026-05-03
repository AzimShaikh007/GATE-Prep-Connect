<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>${material.title} – Reviews | GATE Prep Connect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .reviews-wrap { max-width:860px; margin:2.5rem auto; padding:0 1.5rem; }

        .back-link { color:#6366f1; text-decoration:none; font-size:.88rem; display:inline-flex; align-items:center; gap:.4rem; margin-bottom:1.5rem; }
        .back-link:hover { color:#a5b4fc; }

        .material-hero {
            background:linear-gradient(135deg,rgba(99,102,241,.12),rgba(168,85,247,.08));
            border:1px solid rgba(99,102,241,.25); border-radius:16px;
            padding:1.6rem 2rem; margin-bottom:2rem;
        }
        .material-hero h1 { font-size:1.5rem; font-weight:700; color:#fff; margin-bottom:.4rem; }
        .material-hero p  { color:#94a3b8; font-size:.9rem; }

        .rating-summary {
            display:flex; align-items:center; gap:1.4rem; margin-top:1rem;
        }
        .big-star { font-size:2.8rem; font-weight:700; color:#f59e0b; }
        .star-bar  { display:flex; flex-direction:column; gap:.25rem; }
        .stars-text { font-size:.85rem; color:#94a3b8; }

        /* star display */
        .stars { color:#f59e0b; letter-spacing:2px; font-size:1.1rem; }
        .stars.sm { font-size:.85rem; }

        /* review form */
        .review-form-card {
            background:rgba(15,20,40,.7); border:1px solid rgba(255,255,255,.08);
            border-radius:14px; padding:1.5rem 1.8rem; margin-bottom:2rem;
        }
        .review-form-card h3 { color:#e2e8f0; font-size:1rem; font-weight:600; margin-bottom:1rem; }
        .star-picker { display:flex; gap:.5rem; margin-bottom:1rem; }
        .star-picker label {
            font-size:1.6rem; cursor:pointer; transition:transform .15s;
            color:#4b5563;
        }
        .star-picker input[type=radio] { display:none; }
        .star-picker input[type=radio]:checked ~ label,
        .star-picker label:hover,
        .star-picker label:hover ~ label { color:#f59e0b; }
        /* reversed order trick for CSS-only star rating */
        .star-picker { flex-direction:row-reverse; justify-content:flex-end; }
        .star-picker label:hover,
        .star-picker label:hover ~ label { color:#f59e0b; }

        textarea.review-input {
            width:100%; background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
            border-radius:8px; color:#e2e8f0; padding:.8rem 1rem; font-size:.9rem;
            resize:vertical; min-height:90px; font-family:inherit;
        }
        textarea.review-input:focus { outline:none; border-color:#6366f1; }

        .submit-btn {
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
            color:#fff; border:none; border-radius:8px;
            padding:.55rem 1.4rem; font-size:.88rem; font-weight:600;
            cursor:pointer; margin-top:.75rem; transition:opacity .2s;
        }
        .submit-btn:hover { opacity:.9; }

        /* review cards */
        .review-card {
            background:rgba(15,20,40,.6); border:1px solid rgba(255,255,255,.07);
            border-radius:12px; padding:1.2rem 1.4rem; margin-bottom:1rem;
            transition:border-color .2s;
        }
        .review-card:hover { border-color:rgba(99,102,241,.3); }
        .review-meta { display:flex; align-items:center; justify-content:space-between; margin-bottom:.6rem; }
        .reviewer-name { font-weight:600; color:#e2e8f0; font-size:.9rem; }
        .review-date   { font-size:.75rem; color:#475569; }
        .review-text   { color:#94a3b8; font-size:.88rem; line-height:1.6; }

        .no-reviews { text-align:center; color:#475569; padding:2.5rem; font-size:.9rem; }
    </style>
</head>
<body>
<div class="reviews-wrap">
    <a href="/materials" class="back-link">← Back to Materials</a>

    <!-- Hero summary -->
    <div class="material-hero">
        <h1>${material.title}</h1>
        <p>${material.subject}</p>
        <div class="rating-summary">
            <div class="big-star"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></div>
            <div class="star-bar">
                <div class="stars">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= avgRating}">★</c:when>
                            <c:otherwise>☆</c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="stars-text">${ratingCount} rating<c:if test="${ratingCount != 1}">s</c:if></span>
            </div>
        </div>
    </div>

    <!-- Rate / Edit form -->
    <div class="review-form-card">
        <h3><c:choose><c:when test="${myRating != null}">Edit Your Rating</c:when><c:otherwise>Rate This Material</c:otherwise></c:choose></h3>
        <form method="post" action="/rate-material">
            <input type="hidden" name="materialId" value="${material.id}"/>
            <!-- CSS-only star picker (reversed display) -->
            <div class="star-picker">
                <c:forEach begin="1" end="5" var="i" varStatus="vs">
                    <c:set var="val" value="${6 - i}"/>
                    <input type="radio" id="star${val}" name="stars" value="${val}"
                           ${myRating != null && myRating.stars == val ? 'checked' : ''}/>
                    <label for="star${val}" title="${val} star">★</label>
                </c:forEach>
            </div>
            <textarea class="review-input" name="review"
                      placeholder="Write a short review (optional)…"><c:if test="${myRating != null}">${myRating.review}</c:if></textarea>
            <button type="submit" class="submit-btn">
                <c:choose><c:when test="${myRating != null}">Update Rating</c:when><c:otherwise>Submit Rating</c:otherwise></c:choose>
            </button>
        </form>
    </div>

    <!-- Review list -->
    <h2 style="color:#e2e8f0;font-size:1.05rem;font-weight:600;margin-bottom:1rem;">Community Reviews</h2>
    <c:choose>
        <c:when test="${empty reviews}">
            <div class="no-reviews">No reviews yet — be the first to rate this material!</div>
        </c:when>
        <c:otherwise>
            <c:forEach var="r" items="${reviews}">
                <div class="review-card">
                    <div class="review-meta">
                        <span class="reviewer-name">${r.user.name}
                            <span style="color:#64748b;font-weight:400;">(${r.user.role})</span>
                        </span>
                        <span class="review-date"><fmt:formatDate value="${r.createdAt}" pattern="dd MMM yyyy"/></span>
                    </div>
                    <div class="stars sm">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= r.stars}">★</c:when>
                                <c:otherwise>☆</c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    <c:if test="${not empty r.review}">
                        <p class="review-text" style="margin-top:.5rem;">${r.review}</p>
                    </c:if>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
