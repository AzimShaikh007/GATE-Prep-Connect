-- Fix for Phase 3: Ensure the 'banned' column exists in the 'users' table.
-- Hibernate's ddl-auto=update occasionally fails to add columns in H2 if the table was created in an older phase.

ALTER TABLE users ADD COLUMN IF NOT EXISTS banned BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS bio VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS reputation INTEGER DEFAULT 0;

-- Ensure existing null reputations are set to 0
UPDATE users SET reputation = 0 WHERE reputation IS NULL;

-- Ensure the upvote join table exists (Hibernate might miss this in some H2 versions)
CREATE TABLE IF NOT EXISTS doubt_upvotes (
    doubt_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    PRIMARY KEY (doubt_id, user_id),
    FOREIGN KEY (doubt_id) REFERENCES doubts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
