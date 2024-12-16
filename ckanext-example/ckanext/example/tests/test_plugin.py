import pytest
from ckan import plugins


@pytest.mark.ckan_config("ckan.plugins", "example")
@pytest.mark.usefixtures("with_plugins")
def test_plugin():
    assert plugins.plugin_loaded("example")
