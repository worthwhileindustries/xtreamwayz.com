<?php

declare(strict_types = 1);

namespace App\Domain\Post;

use DateTime;

class Post
{
    /**
     * @var string
     */
    private $id;

    /**
     * @var string
     */
    private $title;

    /**
     * @var null|string
     */
    private $summary;

    /**
     * @var null|string
     */
    private $content;

    /**
     * @var array
     */
    private $tags;

    /**
     * @var DateTime
     */
    private $published;

    /**
     * @var null|DateTime
     */
    private $modified;

    public function __construct(
        string $id,
        string $title,
        string $summary = null,
        string $content = null,
        array $tags = [],
        $published = 'now',
        $modified = null
    ) {
        $this->id      = $id;
        $this->title   = $title;
        $this->summary = $summary;
        $this->content = $content;
        $this->tags    = $tags;

        if (is_numeric($published)) {
            $this->published = (new DateTime())->setTimestamp($published);
        } else {
            $this->published = new DateTime($published);
        }

        if (is_numeric($modified)) {
            $this->modified = (new DateTime())->setTimestamp($modified);
        } elseif ($modified !== false && $modified !== null) {
            $this->modified = new DateTime($modified);
        }
    }

    public function getId(): string
    {
        return $this->id;
    }

    public function getTitle(): string
    {
        return $this->title;
    }

    public function getSummary()
    {
        return $this->summary;
    }

    public function getContent()
    {
        return $this->content;
    }

    public function getPublished(): DateTime
    {
        return $this->published;
    }

    public function getModified()
    {
        return $this->modified;
    }

    public function getTags(): array
    {
        return $this->tags;
    }
}
