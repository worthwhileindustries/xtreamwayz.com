<?php

namespace App\Action;

use Interop\Container\ContainerInterface;
use Psr\Log\LoggerInterface;
use Zend\Expressive\Template\TemplateRendererInterface;
use Zend\InputFilter\Factory as InputFilterFactory;

class ContactActionFactory
{
    public function __invoke(ContainerInterface $container)
    {
        return new ContactAction(
            $container->get(TemplateRendererInterface::class),
            $container->get(InputFilterFactory::class),
            $container->get(LoggerInterface::class),
            $container->get(\Swift_Mailer::class),
            $container->get('config')['mail']
        );
    }
}
