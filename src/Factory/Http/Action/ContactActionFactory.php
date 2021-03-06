<?php

declare(strict_types = 1);

namespace App\Factory\Http\Action;

use App\Http\Action\ContactAction;
use Psr\Container\ContainerInterface;
use Psr\Log\LoggerInterface;
use Zend\Expressive\Template\TemplateRendererInterface;
use Zend\InputFilter\Factory as InputFilterFactory;
use Zend\Mail\Transport\TransportInterface;

class ContactActionFactory
{
    public function __invoke(ContainerInterface $container): ContactAction
    {
        return new ContactAction(
            $container->get(TemplateRendererInterface::class),
            $container->get(InputFilterFactory::class),
            $container->get(TransportInterface::class),
            $container->get(LoggerInterface::class),
            $container->get('config')['mail']
        );
    }
}
