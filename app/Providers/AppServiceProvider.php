<?php

namespace App\Providers;

use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

class AppServiceProvider extends ServiceProvider
{
  /**
   * Register any application services.
   */
  public function register(): void
  {
    //
  }

  /**
   * Bootstrap any application services.
   */
  public function boot(): void
  {
    if (app()->environment('production')) {
        URL::forceScheme('https');
    }
      
    // -------------------
    // GATES
    // -------------------

    // Define a gate that checks if the user is admin
    Gate::define('admin', function () {
      return auth()->user()->role === 'admin';
    });
  }
}
